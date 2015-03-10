module drpg.entities.player;

import drpg.entities.entity;

class Player : Entity{

	char[] name = "Hermando".dup; //Dummy name
	
	this(int xStart, int yStart){
		x = xStart;
		y = yStart;
	}
}