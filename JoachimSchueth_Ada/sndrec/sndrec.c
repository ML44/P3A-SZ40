/*----------------------------------------------------------------------
-- (C)2007 DL2KCD, Joachim Schueth, Bonn.
-- Software written in order to receive and decrypt the transmissions of
-- the Cipher Event on November 15/16, 2007.
----------------------------------------------------------------------*/
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/ioctl.h>
#include <sys/types.h>

static void pex(char *s)
{
    perror(s);
    exit(errno);
}

#ifdef __NetBSD__
#include <sys/audioio.h>
int open_audio(char *devname, int speed)
{
    audio_info_t afo;
    int pn;

    AUDIO_INITINFO(&afo);
    afo.play.sample_rate = speed;
    afo.play.channels = 1;
    afo.play.precision = 16;
    afo.play.encoding = AUDIO_ENCODING_SLINEAR;
    memcpy(&afo.record, &afo.play, sizeof(afo.record));
    afo.mode = AUMODE_RECORD;

    if( (pn = open(devname, O_RDONLY)) < 0 )
        pex("Can't open audio device");

    if( ioctl(pn, AUDIO_SETINFO, &afo) < 0 )
        pex("AUDIO_SETINFO");

    return pn;    
}    
#else
#include <sys/soundcard.h>
int open_audio(char *devname, int speed)
{
    int pn, arg;
    
    if( (pn = open(devname, O_RDONLY)) < 0 )
        pex("Can't open audio device");

    arg = 0;
    if( ioctl(pn, SNDCTL_DSP_RESET, &arg) < 0 )
        pex("SNDCTL_DSP_RESET");

    arg = 0;
    if( ioctl(pn, SNDCTL_DSP_STEREO, &arg) < 0 )
        pex("SNDCTL_DSP_STEREO");

    arg = speed;
    if( ioctl(pn, SNDCTL_DSP_SPEED, &arg) < 0 )
        pex("SNDCTL_DSP_SPEED");
    if( speed != arg )
    {
        fprintf(stderr, "Requested audio sample speed: %d\n", speed);
        fprintf(stderr, "Actual value of sample speed: %d\n", arg);
    }

    arg = AFMT_S16_LE;
    if( ioctl(pn, SNDCTL_DSP_SETFMT, &arg) )
            pex("SNDCTL_DSP_SETFMT");
    if( arg != AFMT_S16_LE )
    {
        fprintf(stderr, "Error: Failed to set DSP format to AFMT_S16_LE\n");
        exit(-1);
    }

    //arg = 0x7fff0009;
    arg = 0x00040009;
    if( ioctl(pn, SNDCTL_DSP_SETFRAGMENT, &arg) == -1 )
        pex("SNDCTL_DSP_SETFRAGMENT");    

    return(pn);
}
#endif

#define RSIZE 512

int main(int argc, char **argv)
{    
    char *devname;
    short rbuff[RSIZE];
    int a, speed, k, nr, nw;

    k = 1;
    if( argc != 3
     || !(devname = argv[k++])
     || sscanf(argv[k++], "%d", &speed) != 1 )
    {
        fprintf(stderr, "Syntax:  %s <devname> <speed>\n", *argv);
        exit(EINVAL);
    }

    a = open_audio(devname, speed);
    for(;;)
    {
        nr = read(a, rbuff, sizeof(rbuff));
        if( nr < 0 && errno != EAGAIN )
            break;
        if( nr > 0 )
        {
            nw = write(1, rbuff, nr);
            if( nw < 0 )
                break;
        }        
    }
    return 0;    
}
