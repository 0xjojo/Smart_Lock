#include <mega16.h>
#include <alcd.h>  
#include <delay.h>
#include <stdbool.h>
bool isValidId(int id); //to check the id entered stored
int getInput(); //to change three digits to integer
unsigned char keypad(); //the get number from keypad
unsigned char EE_Read(unsigned int inputadd);// to get data from EEPROM
void EE_Write(unsigned int inputadd, unsigned int PC); // to write data in address
void Peep();
int   inputPc , id , inputPc_2 ;
int x = 0 ;
int validIDs[5] = {111, 126, 128, 130, 132};

void main(void)
{

	unsigned char passcode;
	DDRD = 0xff ; // set port D as output all 1 for motor and buzzer
	MCUCR = 1 << ISC01 | 1 << ISC00; //choosing the rising edge inttrupt
	MCUCR = 1 << ISC01 | 1 << ISC00; // Trigger INT0 on rising edge
	GICR |= 1 << 6;     //Specific interrupt enable
	MCUCR = 0 << ISC01 | 0 << ISC00; //choosing the low level trigger inttrupt
	GICR |= 1 << 7;     //Specific interrupt enable
	PORTD.1 = 1;
	PORTD.2 = 1;
	DDRB = 0b00000111; // Port B for Keypad
	PORTB = 0b11111000;
	////mapping the EEPROM
	EE_Write(validIDs[0], 203);
	EE_Write(validIDs[1], 129);
	EE_Write(validIDs[2], 325);
	EE_Write(validIDs[3], 426);
	EE_Write(validIDs[4], 179);
	lcd_init(16);  //16 chars/line
	lcd_puts("Enter '*' to \n start ! ");

	while (1) //infinte loop
		{
		x = keypad();
		if (x != '*')
			{
			lcd_clear();
			lcd_puts("Enter *\n");
			}
		else
			{
			lcd_clear();
			lcd_puts("Enter your ID\n");
			id = getInput(); // Make sure it's a valid id
			if(!isValidId(id))
				{
				lcd_clear();
				lcd_puts("Invalid ID\n Enter *");
				continue;
				}
			lcd_clear();
			lcd_puts("Enter your PC\n");
			inputPc = getInput();

			lcd_clear();
			passcode = EE_Read(id);
			if (inputPc == passcode)
				{
				switch (id)
					{
					case 111:
						lcd_clear();
						lcd_puts("Welcome, Prof\n");
						break;
					case 126:
						lcd_clear();
						lcd_puts("Welcome,\n Mohemmed\n");
						break;
					case 128:
						lcd_clear();
						lcd_puts("Welcome, Sherif\n");
						break;
					case 130:
						lcd_clear();
						lcd_puts("Welcome, Ahmed\n");
						break;
					case 132:
						lcd_clear();
						lcd_puts("Welcome, Jojo\n");
						break;

					}

				PORTD.1 = 1;
				delay_ms(2000);
				PORTD.1 = 0;
				lcd_clear();
				continue;
				}
			else
				{
				lcd_clear();
				lcd_puts("Wrong passcode\n Enter *");
				Peep();
				continue;
				}
			}

		};
}


//////////////////////////////////////////////////////////////////////////////
bool isValidId(int id) //to check id is stored in EEPROM
{
	int i;
	for( i = 0; i < 5; i++)
		{
		if (id == validIDs[i])
			return true;
		}
	return false;
}
//////////////////////////////////////////////////////////////////////////////
int getInput()
{
	int code = 0;
	int i, r;
	for (i = 0; i < 3; i++)   // get the ID from user
		{
		code *= 10;
		r = keypad();
		lcd_printf("%u", r);
		code += r;
		}
	return code;
}

//////////////////////////////////////////////////////////////////////////////////////////////Declaring keypad
unsigned char keypad()
{
	while (1)
		{
		PORTB.0 = 0; //C0 is on
		PORTB.1 = 1; //C1 is off
		PORTB.2 = 1; //C2 is off
		switch (PINB)
			{
			case 0b11110110:
				while(PINB.3 == 0); //while the button is pressed
				return 1;
				break;

			case 0b11101110:
				while(PINB.4 == 0); //while the button is pressed
				return 4;
				break;

			case 0b11011110:
				while(PINB.5 == 0); //while the button is pressed
				return 7;
				break;

			case 0b10111110:
				while(PINB.6 == 0); //while the button is pressed
				return '*';
				break;
			}
		PORTB.0 = 1; //C0 is off
		PORTB.1 = 0; //C1 is on
		PORTB.2 = 1; //C2 is off
		switch (PINB)
			{
			case 0b11110101:
				while(PINB.3 == 0); //while the button is pressed
				return 2;
				break;

			case 0b11101101:
				while(PINB.4 == 0); //while the button is pressed
				return 5;
				break;

			case 0b11011101:
				while(PINB.5 == 0); //while the button is pressed
				return 8;
				break;

			case 0b10111101:
				while(PINB.6 == 0); //while the button is pressed
				return 0;
				break;
			}
		PORTB.0 = 1; //C0 is off
		PORTB.1 = 1; //C1 is off
		PORTB.2 = 0; //C2 is on
		switch (PINB)
			{
			case 0b11110011:
				while(PINB.3 == 0); //while the button is pressed
				return 3;
				break;

			case 0b11101011:
				while(PINB.4 == 0); //while the button is pressed
				return 6;
				break;

			case 0b11011011:
				while(PINB.5 == 0); //while the button is pressed
				return 9;
				break;

			case 0b10111011:
				while(PINB.6 == 0); //while the button is pressed
				return '#';
				break;
			}
		}

}
/////////////////////////////////////////////////////////////////////////Address EEPROM
void EE_Write(unsigned int inputadd, unsigned int PC)
{
	while(EECR.1 == 1);  //Wait till the EEPROM is ready for new operation
	EEAR = inputadd; //ADRESS REGEISTER
	EEDR = PC;      //DATA regiester
	EECR.2 = 1;    //EE Master Write Enable
	EECR.1 = 1;    //EEWrite Enable
}
//////////////////////////////////////////////////////////////Read EEPROM
unsigned char EE_Read(unsigned int inputadd)
{
	while(EECR.1 == 1);  //Wait till the EEPROM is ready for new operation
	EEAR = inputadd;
	EECR.0 = 1;          //Read Enable (EERE)
	return EEDR;
}
////////////////////////////////////////////////////////////Change the user PC
void EE_WriteChange(unsigned int inputadd, unsigned int inputCh_1)
{
	while(EECR.1 == 1);  //Wait till the EEPROM is ready for new operation
	EEAR = inputadd;
	EEDR = inputCh_1;
	EECR.2 = 1;    //EEMWE
	EECR.1 = 1;    //EEWE
}
///////////////////////////////////////////////////////// Buzzer function
void Peep()
{
	PORTD.5 = 1;
	delay_ms(1000);
	PORTD.5 = 0;
	delay_ms(500);
}
//////////////////////////////////////////////////////////////////////////Interrupt definition
interrupt [3] void ext1(void)
{
	int pc ;


	lcd_puts("Enter your ID\n");
	id = getInput(); // Make sure it's a valid id
	if(!isValidId(id))
		{
		lcd_clear();
		lcd_puts("Invalid ID\n Enter *");
		}
	lcd_clear();
	lcd_puts("Enter old PC");
	inputPc = getInput();
	lcd_clear();
	pc = EE_Read(id);
	if (pc == inputPc )
		{

		lcd_puts("Enter new PC");
		inputPc = getInput();
		lcd_clear();
		lcd_puts("Re-enter new PC");
		inputPc_2 = getInput();
		if (inputPc == inputPc_2)
			{
			EE_Write(id, inputPc_2 );
			lcd_clear();
			lcd_puts("New PC stored");
			}
		else
			{
			lcd_clear();
			lcd_puts("PCs are not Identical");
			}
		}


}
interrupt [2]void exp0 (void)
{
	int pc;
	lcd_puts("Enter Admin PC");
	id =   getInput();
	if (id == validIDs[0] )
		{
		lcd_clear();
		lcd_puts("Enter student ID");
		id =  getInput();
		lcd_clear();
		lcd_puts("Enter new PC");
		pc =  getInput();
		EE_Write(id, pc);
		lcd_clear();
		lcd_puts("PC is stored");
		}
	else
		{
		lcd_clear();
		lcd_puts("Contact Admin");
		Peep();
		Peep();
		}


}