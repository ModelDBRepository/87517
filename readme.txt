This is the readme for the models associated with the papers:

Bahmer A, Langner G (2006) Oscillating neurons in the cochlear nucleus:
> II. Simulation results. Biol Cybern 95:381—92

the raw files for the Chopper neurons (Topology I and II
corresponding to Bahmer and Langner 2006 I & II

In addition in the "include" folder there are function files which are the
neurons and synapses and some other files that are needed for the
simulation.
The interface for the nerve and the onset simulation is open:

"anft" is the variable for the nerve input (example: 000205010020033...
sampling 25µs). As it is presumed that the chopper have an input of a
frequency channel with 5 synapses it is subdivided. (anft==5 anft==4...)

"onsett" is the variable for the onset neuron input. (only zeros and ones,
example: 001000010000)
Onset neuron is from Rothman and Manis (which is also stored in ModelDB).

The LIF neurons have a stochastic component.

In my simulations, I have simulated the nerve and onset neuron with many
repetitions (the nerve contains stochastic elements) and stored it. The data
was a matrix, in which each colomns are time slits and rows are one
repetition with 25 µs precision.
The next step was that matlab reads one line of nerv ( number for amount of
APs and zeros) and onset (just zeros and ones, ones for an AP) and then
simulates the choppers and stores the chopper result.
This step was repeated as often as the number of repetions.


Andreas Bahmer
Dipl.-Phys.cand.med.
PhD student
- Theoretical Neuroscience -
Technical University Darmstadt
Neuroacoustics
Department of Zoology
Schnittspahnstraße 3
64287 Darmstadt

