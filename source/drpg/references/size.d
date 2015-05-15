module drpg.references.size;

immutable static{
	// World
	int SCREEN_WIDTH = 79;
	int SCREEN_HEIGHT = 24;
	int CHUNK_WIDTH = 50;
	int CHUNK_HEIGHT = 24; //Windows OS standard console size. I'm on windows.
	int CHUNK_AMOUNT_WIDTH = 23;
	int CHUNK_AMOUNT_HEIGHT = 5;
	int WORLD_WIDTH  = CHUNK_WIDTH  * CHUNK_AMOUNT_WIDTH;
	int WORLD_HEIGHT = CHUNK_HEIGHT * CHUNK_AMOUNT_HEIGHT;

	//Room variables
	int MAX_ROOM_WIDTH = 20;
	int MAX_ROOM_HEIGHT = 20;
	int MAX_NUMBER_OF_ROOMS = 100;
}