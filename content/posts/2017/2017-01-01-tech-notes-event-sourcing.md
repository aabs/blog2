---
title: "Tech Notes:  Event Sourcing"
date: 2017-01-01 13:33
author: Andrew Matthews
category: architecture, functional programming, programming
slug: tech-notes-event-sourcing
status: published
attachments: 2017/01/talen-de-st-croix-ufi-_7hx5es-unsplash.jpg
---

**Title**: UPDATE your VIEW on DELETE: The benefits of Event Sourcing
**Speaker**: Sebastian von Conrad of [Envato](https://twitter.com/envato)
**Where**: Melbourne CTO School
**Date**: 2016-12-06




We attended a very entertaining and engaging lecture held at the Envato offices on Even Sourcing, entitled "*UPDATE your VIEW on DELETE" given by Sebastian von Conrad (*[\@vonconrad](https://twitter.com/vonconrad)). This was a meetup organised by the [Melbourne CTO School](https://www.google.com.au/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwir6aGTn_LQAhWCgrwKHRWUCqkQFggbMAA&url=https%3A%2F%2Fwww.meetup.com%2FCTO-School-Melbourne%2F&usg=AFQjCNEj-GqCxcoJL-yftSRslPKLAGb6TA&sig2=eGPSccRAaWs-O0t_fWO3rw) group with a couple of dozen attendees present.

This isn't the first time that Sebastian has given the talk - the same talk was given to the Software Engineering Institute at CMU, and the video for that is available [online](https://youtu.be/_TeMYF_JjNg).

### In a Nutshell

-   A **store of events** is the primary source of truth.
-   Events are **immutable**.
-   Events are stored in an append only **Event Store**.
-   How you **interpret events** is not immutable.
-   Interpretation happens through the action of **Projections**.
-   Projections could be anything, but are often relational databases representing the current state.
-   Projected databases are often **Denormalized** since performance is their primary purpose.
-   Projections can be fine grained and special purpose - e.g. One per view
-   Many different projections of the same data may co-exist.
-   **Queries** happen against a projection of the events- **Clients** communicate with systems using **Commands**.
-   **Events** are created if a command is accepted
-   Whether a command is acceptable/possible or not depends on current state, so clients often also incorporate a projection of some sort.
-   **CQRS** is the segregation of command APIs and query APIs into different components or services.
-   Any data stored in a projection is by definition **disposable** and ephemeral, since the projection is recreated by **replaying** the event stream as needed.
-   To speed up the process of resynchronisation, if necessary, **checkpoint** messages can be generated summarising the state *under a given projection* up to a given point in time.

### Gotchas

-   Busy environments can rack up a very large number of events very quickly.
-   Event Sourcing may be better suited to **read heavy** applications where the projections can stay in sync with the event stream for longer before they become out of sync.
-   The multiple moving parts of the architecture, all being **highly decoupled**, means that the architecture is inherently **eventually consistent**. How far out of sync a projection falls is a deciding factor on how the system propagates events to projections, and how soon.
-   Storing the summarised results of projections in the event stream itself is a kind of data pollution, since events are of the business process realm, whereas projections are of the interpretation domain (one is facts, the other hypotheses or conclusions which is by its very nature provisional)
-   Occasionally event representational flaws are discovered long after the system has been in execution. Correction this requires something like a projectional transformation into a new event store. Something to be avoided as much as a major schema change in a database.

### Observations

-   Event Sourcing has historical pedigree in practices like **double entry bookkeeping**. We would never use a bank that treated our money the way we treat data in relational databases.
-   By segregating the events out in this way, we also segregate the storage of the events from the interpretation of them. This prevents an insidious form of coupling at the conceptual level, often known as the **leaky abstraction**.
-   **Apache Kafka** is an ideal kind of platform for the registering, storage and propagation of events.
-   Envato built their platform on top of the **pub/sub** capabilities of **Postgresql**.
-   Dedicated event stores exist to make such architectures easier.
-   Envato typically start a new project with a phase of **event storming**. A cross between brain storming and User Story authoring geared towards understanding the key transactions of the system.

### Thoughts and Ideas

-   A business event is defined as a **\_fact\_**, at a specific point in time.
-   Storing and interpreting facts (in the sense of **knowledge management**) is at the very heart of the **semantic web** vision.
-   It makes sense to use data formats like **RDF** or **OWL** to represent events.
-   They can be directly incorporated into a **triple store** as a kind of projection, or used as raw material for **inferences.**
-   An **inference engine** can be a kind of projection, and the inferences it deduces from the incoming events can be stored in a projection, becoming a **materialised inference**, which is typically disposable and ephemeral too.
