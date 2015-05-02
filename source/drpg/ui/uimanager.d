module drpg.ui.uimanager;

import std.stdio, drpg.reference, consoled;
import drpg.ui.side, drpg.ui.start, drpg.ui.inventory;
import drpg.entities.player;

class UIManager {

	Start startUI; 
	Side sideUI;
	Inventory invUI;

	static UIManager uim() {
		if (!instantiated_) {
			synchronized {
				if (instance_ is null) {
					instance_ = new UIManager;
				}
				instantiated_ = true;
			}
		}
		return instance_;
	}
	private static bool instantiated_;
	private __gshared UIManager instance_;
	private this() {}

	void init(){
		startUI = new Start(); 
		clearScreen;
		sideUI = new Side(); //Must be created after the player, otherwise ERRORS!
	}
}