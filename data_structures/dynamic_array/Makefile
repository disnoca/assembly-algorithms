CC = gcc
CFLAGS = -Wall -Wextra
AS = nasm
ASFLAGS = -f elf64


C_SOURCES = ../../wrapper_functions.c
AS_SOURCES = dynamic_array.s

TARGET = dynamic_array_tester

all: $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) -o $@  -c $<

%.o: %.S
	$(AS) $(ASFLAGS) $<

$(TARGET): $(TARGET).c $(AS_SOURCES:.s=.o) $(C_SOURCES:.c=.o)
	$(CC) $(CFLAGS) -o $@ $< $(AS_SOURCES:.s=.o) $(C_SOURCES:.c=.o) -g -no-pie

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(AS_SOURCES:.s=.o) $(C_SOURCES:.c=.o) $(TARGET)
