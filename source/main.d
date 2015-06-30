import drpg.game;
import consoled;
import drpg.misc;
import drpg.references.variables;

void main(string[] argv)
{
	auto saved = mode;
	mode = ConsoleInputMode.None;
	scope(exit) mode = saved;
	
	Game g;

	g = new Game();
}

//Thanks to Danol and jA_cOp from #d (freenode) for all the help they gave me!
