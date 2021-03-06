/*
 * main.c
 *
 *  Created on: Sep 1, 2021
 *      Author: fuguanshujie
 */
// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x60; //make a pointer to access the PIO block
	volatile unsigned int *Switch  = (unsigned int*)0x90;
	volatile unsigned int *Accumulate = (unsigned int*)0x80;	// accumulate signal
	volatile unsigned int *Accumu_reset = (unsigned int*)0x70;	// reset signal

	*LED_PIO = 0; //clear all LEDs
	volatile unsigned int accumulator = 0;
	int Pause = 0;
	while ( (1+1) != 3) //infinite loop
	{
		//if (*Accumulate == 1 && Pause == 0) {
		//	accumulator += *Switch;
		//	Pause = 1;		// stop accumulate
		//}
		//if (*Accumulate == 0)	Pause = 0;
		//if (*Accumu_reset == 1) 	accumulator = 0;
		//*LED_PIO = accumulator;
		 for (i = 0; i < 100000; i++); //software delay
		 *LED_PIO |= 0x1; //set LSB
		 for (i = 0; i < 100000; i++); //software delay
		 *LED_PIO &= ~0x1; //clear LSB
	}
	return 1; //never gets here
}




