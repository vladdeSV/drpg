module drpg.references.size;

// World
immutable static int CHUNK_WIDTH = 50;
immutable static int CHUNK_HEIGHT = 24; //Windows OS standard console size. I'm on windows.
immutable static int CHUNK_AMOUNT_WIDTH = 10;
immutable static int CHUNK_AMOUNT_HEIGHT = 5;
immutable static int WORLD_WIDTH  = CHUNK_WIDTH  * CHUNK_AMOUNT_WIDTH;
immutable static int WORLD_HEIGHT = CHUNK_HEIGHT * CHUNK_AMOUNT_HEIGHT;

//Room variables
immutable static int MAX_ROOM_WIDTH = 20;
immutable static int MAX_ROOM_HEIGHT = 20;
immutable static int MAX_NUMBER_OF_ROOMS = 50;