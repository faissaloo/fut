import std.stdio;
import std.conv;
import std.math;
import std.algorithm;
import std.string;
import std.range;
import std.typecons;

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
		//Try and get rid of these dups later, we don't actually need any mutability
		score!(ubyte)(target.representation().dup, value.representation().dup);
	}
	unittest
	{
		auto unitA = new Unit();
		auto unitB = new Unit();

		unitA.score("Start","End");
		unitB.score("End","End");

		assert(unitB.fitness() > unitA.fitness());

		unitA = new Unit();
		unitB = new Unit();

		unitA.score("Start","aaaaaaa");
		unitB.score("Start","Star");

		assert(unitA.fitness() < unitB.fitness());
	}

	auto score(T)(T[] target, T[] value)
	{
		score!(size_t)(target.length, value.length);
		zip(StoppingPolicy.longest, target, value).each!((i) => score!(T)(i[0], i[1]));
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
		return results.reduce!((accumulator, i) => accumulator*i);
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
