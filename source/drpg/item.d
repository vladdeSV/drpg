module drpg.item;

abstract class Item{
	string name;
	
	this(string name){
		this.name = name;
	}
}

class ItemLetter : Item{
	char letter;
	
	this(string name, char letter){
		this.letter = letter;
		super(name);
	}
}