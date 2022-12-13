---
title: Data Centre Strategy
date: 2017-03-21 13:22
author: Andrew Matthews
category: strategy
slug: data-centre-strategy
status: published
---

Do the fundamentals matter? {#popover311813 .popover .fade .top .in}
---------------------------

Last week I was at the [Cloud and Data Centre Edge](http://www.adapt.ventures/the-edge-experiences/cloud-dc-edge-2/) Conference. It was a great trip, and I had the chance to chat with various leaders in the Australian data centre and cloud industry. The conversations continued after the conference was over, and one in particular was with a member of our investment analysis team.




They wanted to know more about UniSuper's data centre policy and my impressions of the conference. The discussion was wide ranging, and I've been thinking  about it ever since.  I think the different ways we looked at the topic illustrated an interesting difference between the quantitative and qualitative approaches to understanding.  I have written about this kind of thing in the past in relation to semantic web technologies and search technology.  It's interesting that the problem reoccurs even when discussing something like the suitability of investing in data centres.

What was most counter-intuitive (for me) was how an analyst might gauge the investment opportunity in data centres in terms of gross megawatts of power used. I must confess I was thrown at first, thinking they were discussing an entirely different topic. But then it struck me - these are quantitative analysts and their approach was akin to technical analysis.  The object of their analysis is not a share price, but the same principle holds.  Megawatts used is an indicator of the health of the industry. The more megawatts a data centre consumes, the more it must be in use, right? Well, the answer might be right in the short term, but in the long term the answer is anything but simple.

[Technical Analysis](https://en.wikipedia.org/wiki/Technical_analysis) is the prediction of a stock price using trends in historical data. The working assumption is that the market price is a reflection of the fundamental health of the company (assuming the rest of the industry has looked at the fundamentals).  By all accounts, chart analysis can be an effective predictor of future trends in stock prices. What I don't know is whether it is an effective approach during ***periods of volatility?***

The economics of the data centre and cloud industry are complex and non-linear, and the energy expenditure of its customers is constantly changing. While it's probably a safe bet to invest in data centres, how the industry is changing is harder to predict. What kinds of technology should receive maximum investment, and how will usage change over time?

It's illustrative to look at the difference between a numerical indicator like power consumption and a more complex (and laborious) model of the effects of social trend. We see a similar difference between machine learning techniques and symbolic or logical computing models.  Quantitative models are often more practical, providing a shortcut to a prediction but bypassing any prospect of a deeper understanding of the strategic picture which may be more valuable in the long term.

Strategy is more valuable than tactics in the long run - wars are not won on tactics alone.  I don't think that idea is even contentious generally, but it's hard these days to get people to invest their time in strategic foresight.

> *Strategy without tactics is the slowest route to victory. Tactics without strategy is the noise before defeat.*        Sun Tzu

Trends Affecting Data Centre Use
--------------------------------

::: {.o_image_floating .pull-right .s_image_floating .o_margin_l}
::: {.o_container}
:::
:::

::: {.wp-block-image .img .img-rounded .img-responsive .alignright}
![Successive waves of technology will influence where, when and how we use DCs or Cloud. ](http://www.publicdomainpictures.net/pictures/80000/velka/the-great-wave-kanagawa.jpg)
:::

::: {.o_footer}
There are several trends influencing data centre use. Here are some key examples. I hope they illustrate that deeper strategic foresight helps interpret the technical figures and paints a more colourful picture of the strategic landscape.
:::

### Trend 1: Containerisation Reducing Wasteful Computation

The primary economic force at work in any technology dependent company is around maximising the return on your hardware investment, or to put it another way - *using your machines as close to capacity as is safe*. The current containerisation revolution is just the latest manifestation of that. With Docker, we spend more time doing business relevant computation and less of it simulating operating systems. We also waste less RAM quota on the OS and more on processes*.*

With less surplus computation going on per 'service', the more services we can pack onto a given server. In other words, we get a MUCH higher density of compute per server than with VMs. Ultimately, from a CTO or CIO's perspective, this translates to the bottom line of less money spent on data centre or cloud hosting.  To get a sense of just how much more density can be achieved [Nicolas De loof](https://twitter.com/ndeloof) recently demonstrated that even a Raspberry Pi 2 could host [2740 docker containers](https://twitter.com/ndeloof/status/653828206835970048?ref_src=twsrc%5Etfw&ref_url=https%3A%2F%2Fblog.docker.com%2F2015%2F10%2Fraspberry-pi-dockercon-challenge-winner%2F).

This trend, when played out across the whole world and all industries sees a net reduction in data centre power consumption. Yet, in terms of fundamentals, it is extremely positive from an investment perspective. It represents customers getting much more compute for their dollars, which will be a positive growth driver.

### Trend 2: Changes as Technologies Adapt to the Container Revolution

As with the economics of containerisation, there is a similar force at work in the world of software engineering, that negatively impacts gross wattage consumed. That is the rise of container friendly systems programming languages.

At CDC Edge conference we heard a talk from [Yuval Bachar](http://www.itnews.com.au/blogentry/linkedins-data-centre-lead-to-keynote-cloud-dc-edge-2017-440881), the architect behind LinkedIn's infrastructure expansion. LinkedIn, as a result of their recent acquisition by Microsoft need to expand aggressively. They expect to reach a million servers in the process. Microsoft, Apple, Google and others are already working at a much larger scale than that, and the efficiency of their software development technology stacks can be felt in terms of energy and storage overheads.

Interestingly, in a round table discussion forum on microservices led by [Glenn Gore](https://www.linkedin.com/in/goreg/), chief architect at Amazon Web Services, we heard that when productising a service for roll out across the millions of servers at their disposal, Amazon will frequently port the services into Java from whatever funky new tech stack was used by the original developer.

This makes a lot of sense, until you consider that a container with a complete JDK platform is currently at least 100MB or more in size. The base java image will be shared across all containers on a host, but the memory footprint is still larger than it should be.

::: {.o_image_floating .pull-right .s_image_floating .o_margin_l}
::: {.o_container}
:::
:::

::: {.wp-block-image .img .img-rounded .img-responsive .alignleft}
![google will sometimes tell you docker image sizes if you ask it nicely](https://www.industrialinference.com/web/image/906)
:::

::: {.o_footer}
The Go programming language has a static compilation feature allowing compilation production of a single executable with no unnecessary code or external dependencies. This executable [can run on the scratch Docker container](https://blog.codeship.com/building-minimal-docker-containers-for-go-applications/) (a zero size base layer with no frameworks added at all), reducing still further the consumption of resources on a host machine and increasing the density achievable per machine. This is in effect, tackling the next bottleneck that arises after you move to containers - how can you fit more of them on a machine.
:::

Nicolas De loof's feat with the Raspberry Pi 2 demonstrates that, at least for static site hosting, there are some truly efficient deployment scenarios. His feat also illustrates that normally developers are typically more concerned with boosting their own productivity rather than the efficiency of their deliverables. When working at scale a different approach is required, and size does matter.

Clearly, Amazon's approach is based on many other considerations, but in time I expect we shall see compiler vendors coming under increasing pressure to optimise for the ultra-light-weight deployment scenarios that makes Go a compelling proposition.  In an IoT environment, this is extremely relevant.  The cost of memory chips may be low, but when you have to roll out 50 billion of them, every byte counts.  If you can afford to downsize the RAM, you may save many billions of dollars globally.  Clearly, it's a compelling case for manufacturers to support the leanest deployment model possible.

Anyway, this all adds up to a technology trend that will see us get more bang for our buck out of the physical kit we use. This will reduce expenditure for CTOs and increase profit for manufacturers - what this all boils down to in the end. This cost reduction trend will dampen the acceleration in data centre power usage while increasing the business value of the data centre.

### Trend 3: Rise of AI

::: {.o_image_floating .s_image_floating .pull-left .o_margin_l}
::: {.o_container}
:::
:::

::: {.wp-block-image .img .img-rounded .img-responsive .alignright}
![AI is inherently compute intensive - good news for DCs](https://www.industrialinference.com/web/image/916)
:::

::: {.o_footer}
Many companies are just starting to think about their migration to cloud and to invest in Machine Learning. The transition they are making will result in different kinds of workload that will impact the utilisation profile of a typical data centre.
:::

Where their systems are normally focussed purely on delivering core functionality without attempting to do more with the data at hand, the drive to add intelligence will exert pressure to both generate and consume more data in the pursuit of business insights.

Organisations that traditionally have not considered themselves in the Big Data category, and who sniggered at the early adverts to go to the cloud, will find that they generate vastly more data than they thought possible.

As a case in point, UniSuper is in this category and we were recently considering the use of Kafka as a platform for publication and consumption of event data. When we looked at our log traffic we realised we already generate up to 150,000 messages per second. We currently need to ingest that for security and fraud analysis, but there are other business insights amongst all that data just waiting to be found.

Once we started thinking in terms of broadcasting everything going on onto something like a Kafka cluster, it also became clear we were in need of new architectures and infrastructure to support machine learning.

Many other organisations will be having the same realisation about now. The firehose of data must be processed both in real time (for things like security analytics and real user monitoring), and requires serious compute power to run AI algorithms over it.

The industry will therefore need a permanent large scale compute capability for 'fast data'. It will also need elastic compute capabilities for periodic storage, bandwidth and compute intensive workloads. Both aspects of the trend point towards an increased demand on cloud resources. A positive for data centre investments.

### Trend 4: Edge computing

Needless to say, all of that costs money, and a CIO is often concerned with driving down costs, so solutions must be found to reduce the financial impact of all this data science.

At CDC Edge we heard from various commentators about the torrent of data being generated in various industries. One example came from the auto industry, where these days a modern autonomous vehicle is better thought of as a 'Data Centre on Wheels'.

By some estimates, an autonomous vehicle will generate upwards of 4TB of data per day, from the many sensors it has on board. This data can't all be transmitted via cellular networks, even if they use 5G networks, the latency and cost alone would prohibit it. So the only recourse is to process it locally, and transmit the results.

::: {.o_image_floating .o_margin_l .pull-right .s_image_floating}
::: {.o_container}
:::
:::

::: {.wp-block-image .img .img-rounded .img-responsive .alignleft}
![Cars generate a lot of data that is not cost effective or safe to process centrally](http://www.chipsetc.com/uploads/1/2/4/4/1244189/6873681_1_orig.png)
:::

::: {.o_footer}
In optimising cloud based telephony systems, I was faced with similar challenges - real-time systems need very lean and mean data transport policies and to take advantage of compute wherever they find it. Why use the server-side rendering capabilities of frameworks like ASP.NET when you can create single-page applications and offload page rendering and even state management and storage to the browser?
:::

The result in my case was transforming the system from a glorified client-server to a grid computing architecture. We get a load more bang for buck out of our cloud infrastructure, which in that case meant increased profit.

Edge computing is a venerable design pattern - When bandwidth costs or latency delays are high, move the computation to where the data is. This is the principle behind the stored procedure. Many other modern use cases call for edge computing too. The rise of mobile as the channel of choice, means that more traffic is being pushed over cellular networks.

Many providers of data-intensive services find it convenient to intercept that traffic before it enters the network. This phenomenon is called *Mobile Edge Computing*. It sees telephone companies making Data Centres in a shipping container (so called *microDCs*) available beside cell phone towers.

Smart City infrastructure may leverage this capability to send results back to city managers and coordinating systems at the central DC. There was even talk at the conference about this mobile edge computing capability being used for face recognition and surveillance. Clearly, the architectures will be hybrid - the police are not going to store their central database in each and every shipping container, so partial results will be sent pack for use in the central DC. This kind of model will be probably more common. and it again show that while there is an upward trend generally, it is dampened by cost issues and new architectures.

### Trend 5: High Speed Mobile Networks

Trials are going on worldwide in preparation for the rollout of 5G. We heard from Hauwei on how they were going on this project. They are exploring edge computing in media production. In broadcasting, there is an increase in live on-location streaming. That's hard to do when the production of UHD video footage needs high computation loads for video processing, and high bandwidth use for streaming down stock footage. compounding the difficulty, VR broadcasts require up to 72Gbps bandwidth to be used. Hauwei sees 5G as an enabling technology that will be a springboard for new kinds of media and broadcasting.

This exemplifies the kinds of astonishingly data intensive uses we will put 5G to when it arrives in around 2020. The sheer quantity of data it will allow will swamp data centres and create an increased reliance on edge computing. Having said that, the sheer amount of data means our need for data centres will probably still continue to grow, but the need for edge computing will drive new norms in software architecture as companies go mobile first.

### Trend 6: Smart Cities, Urbanisation and IoT

::: {.o_image_floating .s_image_floating .o_margin_l .pull-left}
::: {.o_container}
:::
:::

::: {.wp-block-image .img .img-rounded .img-responsive .alignleft}
![Urbanisation and smart city development means IoT message loads will rise rapidly worldwide, creating a need to pre-process data on the edge. ](https://www.industrialinference.com/web/image/918)
:::

::: {.o_footer}
People worldwide have been gradually moving from rural communities to cities for hundreds of years, but the rate they've been doing it has risen sharply in the last few decades. Hundreds of millions will move into cities in places like India and China in  the next decade or two. The magnitude of the challenge this poses is enormous - new cities are being constantly built to house these new arrivals. City builders are faced with a challenge - they seem to in some cases be replicating the street plan of 'evolved' cities to ensure the cities are livable in ways that planned cities typically are not. Governments are also investing in smart city technology to increase the livability and governability of these new cities.
:::

Estimates are as high as \$248 trillion for the total infrastructure investment needed to complete the urbanisation of the world. Large proportions of the population are getting mobile phones at the same time that they enter employment in the cities. It's quite likely that much of the new city infrastructure and the consumption of its services will be via mobile telephony networks.

Estimates are that there will be a 10:1 ratio between humans and IoT devices. All of these devices are likely to communicate back to base regularly. This will naturally create a backlog of sensor data to process, and workloads will be handled locally to reduce costs and latency. 100 billion IoT devices all chatting away over 5G is likely to create a lot of data! Again, this is a positive influence on the prospects for data centres, but will involve changes in how we use our data.

### Trend 7: Serverless Computing

So we've seen some trends that inflate our use of data centres, and some that deflate them. The last trend I wanted to mention was the [Serverless](https://en.wikipedia.org/wiki/Serverless_computing) computing movement, which capitalises on the fast lightweight nature of Docker containers to allow ephemeral computation to be brought to streaming data.  Another way to describe this is as Function as a Service.

Once again, the trend at work here is driven by costs. Why keep a container or VM running when there is no work to do? Why not just scrap it and restart it when new data comes in. This is a practical and compelling scenario when Docker containers can be (re)started in milliseconds, and orchestrated at large scales by technologies like Kubernetes.

Services like [hyper.sh](https://hyper.sh/) provide just this kind of capability combined with per-second billing rates to allow companies to use as little of the resources of a data centre as they can. This is a final trend that will reduce the consumption of data centre resources.

So, is it better to know the trends or the charts?
--------------------------------------------------

After all is said and done, when you are just considering whether investing in data centres is a safe bet or not, you don't need to know the strategic view. All you really need to know is that all indications are that our use and reliance on data centres will only increase over time, regardless of how efficient the technologies are that we use on them.

But knowing ***why*** that is assured is powerful knowledge. As you can see from all the trends and considerations above, there is a lot to know about this space. The way we will do software engineering in the future will change, based on how we live, where we live and what technology we use to support us in our daily lives. That knowledge can inform other decisions on other technologies.

As some have said about logic programming and symbolic computing generally, the effort needed to produce a good model is higher than for statistical techniques. But if you have a good one, it will shed more light on your domain than a numerical model.

This is the dilemma that sits at the heart of software engineering today. Most companies would benefit massively from a rich model of their domain and how it works. Such models require careful thought and a broader long-sighted perspective. Most companies opt for the quick win, but they end up with point solutions addressing only the need at hand without capturing or propagating deeper knowledge for others to use.  In the long run, they reach a limit of what they can do with their data.

Thinking deeply and clearly about your problems is my stock in trade.  Get in touch to hire me.
