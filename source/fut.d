import std.stdio;
import std.conv;
import std.math;
import std.algorithm;

class Unit
{
	real[] results = [];

	auto score(T)(real target, real value)
	{
		results ~= 1-fabs(target - value)/(pow(2, T.sizeof*8)-1);
	}
	unittest
	{
		auto unitA = new Unit();
		auto unitB = new Unit();

		unitA.score!(ulong)(65536, 141592653589);
		unitB.score!(ulong)(25565, 141592653589);

		assert(unitA.fitness() > unitB.fitness());
	}

	auto score(bool target, bool value)
	{
		results ~= target & value;
	}
	unittest
	{
		auto unitA = new Unit();
		auto unitB = new Unit();

		unitA.score(true,true);
		unitB.score(true,false);

		assert(unitA.fitness() > unitB.fitness());
	}

	auto score(string target, string value)
	{
		results ~= 1-levenshteinDistance(target, value).to!real/max(target.length, value.length);
	}
	unittest
	{
		auto unitA = new Unit();
		auto unitB = new Unit();

		unitA.score("Start","End");
		unitB.score("End","End");

		assert(unitB.fitness() > unitA.fitness());
	}

	auto score(T)(T[] target, T[] value)
	{
		results ~= 1-levenshteinDistance(target, value).to!real/max(target.length, value.length);
	}
	unittest
	{
		auto unitA = new Unit();
		auto unitB = new Unit();

		unitA.score!(int)([1,3],[1,2]);
		unitB.score!(int)([1,3],[1,2,2]);

		assert(unitA.fitness() > unitB.fitness());
	}

	auto fitness()
	{
		return mean(results);
	}
	unittest
	{
		auto unitA = new Unit();
		auto unitB = new Unit();

		unitA.score!(ulong)(65536, 141592653589);
		unitA.score!(ulong)(65536, 141592653589);
		unitB.score!(ulong)(25565, 141592653589);
		unitB.score!(ulong)(65536, 141592653589);

		assert(unitA.fitness() > unitB.fitness());
	}
}
