JFLAGS = -g
JC = javac
.SUFFIXES: .java .class
CLASSES = \
	Baudot.java \
	Rotor.java \
	Traduction.java \
	Key.java \
	Lorentz.java \
	SZ40.java \
	
default: classes

.java.class:
	$(JC) $(JFLAGS) $*.java

classes: $(CLASSES:.java=.class)

clean:
	$(RM) *.class

new: clean classes