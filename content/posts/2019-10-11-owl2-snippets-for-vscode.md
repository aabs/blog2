---
title: OWL2 Snippets for VSCode
date: 2019-10-11 10:00
author: aabs
category: Semantic Web
ignored-tags: owl, RDF, snippets, vscode
slug: owl2-snippets-for-vscode
status: published
attachments: 2019/10/juan-gomez-kt-wa0gdfq8-unsplash.jpg
---

I put together a list of OWL2 snippets for Visual Studio Code, for use with Turtle ( `*.ttl `) files.

https://github.com/aabs/owl-2-turtle-snippets

The shortcuts cover most of the OWL2 Reference Card. Enjoy.




command                              shortcut
------------------------------------ --------------
class                                `/c `
add label                            `rlab `
add comment                          `rcom `
object property                      `ropr `
time value                           `rtime `
intersect class                      `rintersect `
class intersection                   `/ci `
class union                          `/cu `
class complement                     `/cc `
class enumeration                    `/ce `
subclass                             `/csub `
equivalent classes                   `/cequ `
disjoint classes                     `/cd `
pairwise disjoint classes            `/cda `
disjoint union                       `/cdu `
universal                            `/pru `
existential                          `/pre `
individual value                     `/pri `
local reflexivity                    `/prx `
exact cardinality                    `/prc `
qualified exact cardinality          `/prcqxc `
maximum cardinality                  `/prcmax `
qualified maximum cardinality        `/prcqmax `
minimum cardinality                  `/prcmin `
qualified minimum cardinality        `/prcqmin `
n-ary universal                      `/prdu `
n-ary existential                    `/prde `
inverse property                     `/pv `
data range complement                `/drc `
data range intersection              `/dri `
data range union                     `/dru `
literal enumeration                  `/denum `
datatype restriction                 `/drs `
subproperty                          `/ppsub `
chain inclusion                      `/ppch `
domain                               `/ppdom `
range                                `/ppran `
equivalent properties                `/ppequ `
disjoint properties                  `/ppd `
all disjoint properties              `/ppdd `
inverse properties                   `/ppinv `
functional property                  `/ppfun `
inverse functional property          `/ppinfu `
reflexive property                   `/ppref `
irreflexive property                 `/ppirref `
symmetric property                   `/ppsym `
Asymmetric Property                  `/ppasym `
Transitive Property                  `/pptrans `
equality                             `/aeq `
prinequality                         `/ane `
individual inequality                `/aane `
assertion                            `/ac `
object property assertion            `/aprop `
negative object property assertion   `/anprop `
name                                 `//l `
comment                              `//c `
addition information                 `//ai `
agent                                `//da `
information                          `//v `
deprecation                          `//dep `
backwards compatibility              `//bc `
incompatibility                      `//incomp `
prior version                        `//pv `
