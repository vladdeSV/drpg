import std.stdio, std.random, consoled;
import drpg.game, drpg.reference;

void main(string[] argv)
{
	Game g = new Game();

	g.start();

	centerStringOnEmptyScreen("GAME HAS ENDED");
}

//Thanks to Danol and jA_cOp from #d on freenode for all the help they gave me!
