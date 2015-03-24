module drpg.ui.uimanager;

import std.stdio, drpg.reference, consoled;
import drpg.ui.side, drpg.ui.start, drpg.entities.player;

class UIManager {

	Start startUI; 
	Side sideUI;

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
	private static bool instantiated_;  // Thread local
	private __gshared UIManager instance_;
	private this() {

		//Prints out the border of the chunk
		foreach(y; 0 .. CHUNK_HEIGHT){
			setCursorPos(CHUNK_WIDTH, y);
			write("+");
		}
		foreach(q; 0 .. CHUNK_WIDTH + 1){
			setCursorPos(q, CHUNK_HEIGHT);
			write("+");
		}
	}

	void init(){
		startUI = new Start(); 
		clearScreen;
		sideUI = new Side(); //Must be created after the player, otherwise ERRORS!
	}
}