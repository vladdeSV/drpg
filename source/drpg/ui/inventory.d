module drpg.ui.inventory;

import drpg.ui.uimanager;
import drpg.misc;

class Inventory
{
	UIManager uim;
	bool inventoryOpen = false;

	this(UIManager uiman)
	{
		uim = uiman;
	}

	void openInventory(){
		inventoryOpen = true;

		clearChunk();



		while(inventoryOpen){

		}
	}
}

