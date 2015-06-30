module drpg.item;

import std.conv;
import drpg.misc;

class Inventory{
	
	ItemLetter[26] letters;

	this(){
		foreach(n; 0 .. to!int(letters.length)){
			letters[n] = new ItemLetter(alphabetLC[n]);
		}
	}

	void addLetter(char letter){
		letters[locationInAlphabet(letter)].amount += 1;
	}

}

class ItemLetter{
	char letter;
	int amount = 0;
	
	this(char letter){
		this.letter = letter;
	}
}


//This was for when I though about having ordianry items, such as a sword, lamp etc.
	/+
		if(to!int(letters.length) < maximumAmountOfItems){}
	int maximumAmountOfItems = 26;
	this(int maxItems = 26){
		maximumAmountOfItems = maxItems;
	}
	Item[] items;
	void addItem(Item item){
		if(to!int(items.length) < maximumAmountOfItems){
			items ~= item;
		}
	}
	+/
/+
abstract class Item{
	string name;
	
	this(string name){
		this.name = name;
	}
}
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
+/
