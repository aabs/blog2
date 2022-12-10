---
title: Brain modeling - first steps
date: 2005-07-27 09:11
author: Andrew Matthews
tags: artificial intelligence, Computer Science, medicine
slug: brain-modeling-first-steps
status: published
---

The following appeared in Kurtzweil AI:

IBM and Switzerland's Ecole Polytechnique Federale de Lausanne (EPFL) have teamed up to create the most ambitious project in the field of neuroscience: to simulate a mammalian brain on the world's most powerful supercomputer, IBM's Blue Gene. They plan to simulate the brain at every level of detail, even going down to molecular and gene expression levels of processing.

Several things come to mind after the initial "coooooooooooooool!!!!!". The first is that they are considering a truly vast undertaking here. Imagine the kind of data storage and transmission capacity that would be required to run that sort of model. Normally when considering this sort of thing, AI researchers produce an idealised model where the physical structure of a neuron is abstracted into a cell in a matrix that is able to represent the flow of information in the brain in a simplified way. What these researchers are suggesting is that they will model the brain in a physiologically authentic way. That would mean that rather than idealising their models at the cellular level they would have to model the behaviour of individual synapses. They would have to model the timing of the signals within the brain asynchronously, which would increase both the processing required and the memory imprint of the model.

Remember the success of the model of auditory perception that produced super-human recognition a few years ago? That was based on a more realistic neural network model, and had huge success. From what I can tell it never made it into the mainstream voice-recognition software because it was too processor intensive. This primate model would be orders of magnitude more expensive to run, and despite the fact that Blue Gene can make calculations at a rate of 2 per micrometre at the speed of light, it will have a lot of those to do. I wonder how slow this would be compared to the brain modeled.

I also wonder how they will quality check their model. How do you check that your model is working in the same way as a primate brain? Would this have to be matched with a similarly ambitious brain scanning project?

Another thing that this makes me wonder (after saying cool a few more times) is what sort of data storage capacity they would have to expend to produce such a model? Lets do a little thumbnail sketch to work out what the minimum value might be based on a model of a small primate like a squirrel monkey with similar cellular brain density to humans but a brain weighing only 22 grams (say about 2% of the mass of the brain).

-   Average weight of adult human brain = 1,300 - 1,400gm
-   Number of synapses for a "typical" neuron = 1,000 to 10,000
-   Number of molecules of neurotransmitter in one synaptic vesicle = 10,000-100,000
-   Average number of glial cells in brain = 10-50 times the number of neurons
-   Average number of neurons in the human brain = 10 billion to 100 billion

If we extrapolate these figures for a squirrel monkey the number of neurons would be something like 1 billion cells, each with (say) 5,000 synapses each with 50,000 neurotransmitters. Now if we stored some sort of data for the 3D location each of those neurotransmitters we would need a reasonably high precision location maybe a double precision float. That would be 8bytes \* 3 dimensions \* 50000 \* 5000 \* 1,000,000,000 which comes out at 6,000,000,000,000,000,000 bytes or 5-6 million terabytes. Obviously the neuro-transmitters are just a part of the model. The patterns of connections in the synapses would have to be modeled as well. If there are a billion neurons with 5000 synapses, there would have to be at least 5 terabytes of data for synaptic connections. Each one of those synapses would have its own state, and timing information. Maybe another 100 bytes or more for that information or another 500 terabytes.

I suspect that the value of modeling at this level is marginal, when they could represent the densities of neurotransmitters over time they could save the cost of data storage hugely. I wonder of there is 6 million terabytes of storage in the world! If each human on earth contributed a megabyte of storage then we might be able to store that sort of data.

Lets assume that they were able to compress the data storage requirements through abstraction to a millionth of the total I just described, or around 6 terabytes. I assume that at all times the synapses would be visited to update their status. That means that if the synapses were updated once every millisecond (which rings a bell, but may be too fast) then the system would have to perform 6 \*10\^15 operations per second. Assuming also that the software would have numerous housekeeping tasks and structural tasks to perform, so it might be no more than 25% efficient, in which case we are talking 2.4\*10\^16 operations per second. Blue Gene/L system they will be using is able to perform 2.28\*10\^12 flops, therefore they would take around 1000 seconds to perform one cycle of updates.

They will be restricting their models to cortical columns that would restrict their model to about 100 million synapses, which would be much more manageable in the short term. I wonder how long it will take before they are able to produce a machine that can process a full model of the human brain?
