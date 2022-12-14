---
title: Policy and Configuration I
date: 2006-04-04
author: Andrew Matthews
ignored-tags: Code Generation, programming
slug: policy-and-configuration-i
status: published
---

A couple of posts ago, I said I'd explore the issues of code generation, DBC and ORM. The first thing I wanted to do is address the issue of '*policy vs configuration*'. Every project has to address this issue in some way, most systems are developed on a platform that varies from its deployment environment. Most software must be tailored to behave differently on different platforms. Typically, a developer environment is different from a production environment, with some resources replaced by mock objects or stubs. The differences have to be communicated to the software and that's where configuration comes in.

I've seen the following strategies employed in the past:

-   Configuration file stored in a well-known location that is loaded at system start-up.
-   Configurations stored in a database.
-   Compile-time settings used to choose between settings (using \#if pragmas)
-   Compile-time settings used to do search and replace on regex tokens in the system.

I'm not interested, for the sake of this argument, in the format the settings data uses. Conceptually, it is irrelevant whether the config settings are provided as XML, name-value collections, or serialised objects. The key scenarios are listed above, and they are certainly the most common. More elaborate APIs can be built on top of them, which goes some way towards providing a typed encapsulation to the settings system. .NET provides in-built support for the first most common scenario. The Enterprise Library provides support for serialised objects. It is a great improvement, but has not penetrated far into the standard practice of the .NET community. One can only hope that it will, eventually.

Another common strategy is the use of the hierarchical or cascading config system. I have called it a cascading config system because of its similarity to the mechanism of cascading style sheets. In a cascading config system a default set of properties are initially set up and then overridden selectively with configurations that define how the settings for the current system differ from the default. Typical layouts are just two layers deep, with default settings being loaded first and then instance specific version overloading where appropriate, although I have worked on systems that provide up to five levels of overloading.

Ultimately the provenance of a run-time configuration setting is not as important to the developer as how it is presented to the system (except when it goes wrong). One important factor is how well encapsulated the configuration system is from the vagaries of config fashion. Often, with a long term project where staff turnover is high, you may find that numerous approaches are used leading to a confusion within the team about where to get a setting and how one can override it without bringing down the whole system. Without consistency you may find configs being ignored in favour of hard coded settings because only then can the programmer be sure that the setting is what they need it to be.

***Unless the configuration system is clean, well ordered and consistent, code will eventually become brittle, unpredictable, opaque and non-deterministic**.*

There is another issue with how config systems are generally presented to the rest of the system. Normally, an object-oriented designer would frown at exposing raw data from a data source in an untyped way. It creates points in the system where explicit checks have to be performed to convert types, check formats, check business rules and so on. Configuration code is often not well isolated, it can be diffused throughout the whole system so it will be hard to convert a config system after the fact. The best way to overcome this is to provide a typed wrapper around the configuration settings. Which of these scenarios would you prefer?

    string maxRecipients = ConfigManager.GetConfig(MAX_RECIPIENTS);

    if (maxRecipients != null && maxRecipients != ""){
      int mr = Convert.ToInt32(maxRecipients);
      if (mr > 0 && mr < SOME_UPPER_LIMIT)
        IList someData = GetRecipients(mr);
      SendTo(someData);

Or something like this:

    IList someData = GetRecipients(MailSettings.MaxRecipients);
    SendTo(someData);

Admittedly, I'm taking some artistic liberties here; I'm assuming the MailSettings config class enforces business rules and gets initialised appropriately. The point is that, in our business rules, we should not have to be interested about the format or origin of configuration data. In fact ***we should not even know that we have a config system!*** Configuration is a convenience that makes distributed systems and testing easier. Generally it makes development harder for the reasons described above. I've worked with config systems so byzantine that it became a lottery whether unit tests would run consistently between developer machines. That's where the brittleness of configuration arises from. Subtle dependencies arise between security settings, config files, availability and access to resources and run-time identities. Many of these implicit dependencies are in areas that get little or no attention by the development team, often being neglected till the project is in its final user acceptance testing phase. My first contention is therefore that ***configuration settings should always be typed, and should always be well documented and predictable***. This sounds like good advice for all software, and that's true, but config plays a special part in most software systems and thus tends to get neglected in favour of some unencapsulated string based name value collection mechanism.

What does the injunction mean in practice? It means that whatever the format that you store the settings in, you should deserialise them into an object that exposes them as typed properties. In the case of things like connection strings, they require no conversions, but for other types the conversion should be done immediately. In some software systems the config system is so useful and all-pervasive that programmers come to rely heavily on them. They resort to config settings for things that have no place outside of source code. Excessive reliance on config settings can lead to serious performance deficits with continuous type conversions and checking finding their way into every method.

As mentioned before, if you have config settings that are overridden as the platform definition gets more specific, you get a configuration inheritance hierarchy. My next point is: *If you are going to provide a typed interface to configuration, why not use explicit object-oriented inheritance hierarchies to encapsulate it?* Consider the following model:

    public interface IMailSettings{
     string MailServer{get;set;}
     string DefaultFromAddress{get;set;}
    }

    public class MasterMailSettings : IMailSettings{
     public virtual string MailServer{get{...}set{...}}
     public virtual string DefaultFromAddress{get{...}set{...}}
    }

    public class DevMailSettings : MasterMailSettings{
     public override string MailServer{get{...}set{...}}
    }

The effect is the same, but the implementation is supported by the language and the idiom is much more harmonious with that of the rest of the system. The same arguments that justify the use of typed data access layers or object relational mapping systems apply here. There are numerous design patterns that can be used to improve performance and consistency. In fact we could describe part of our problem as an '*object/configuration impedance mismatch*' to paraphrase Scott Ambler. Normally, we're at liberty to change the format of our config files to make deserialising into typed containers easier, but as with relational systems, people often find it hard to justify expending the up-front effort to produce a system that does this automatically. That's why the config system of the enterprise library is such a welcome addition.

Since in a hierarchical configuration system, default settings are often left unchanged for long periods and get stored as embedded resources, if you want to change them you have to recompile the assembly and restart the application. Aside from leading to a potential violation of service level agreements, this practice undermines the whole point of config files - that of being run-time control of program behaviour. In this circumstance ***you might as well employ an object-oriented class hierarchy and dispense with default configurations altogether***.  I don't think that in 20 years of programming I have ever seen this approach used. Maybe the reason is that people fail to see that polymorphism provides a nice little work-around for overriding default behaviours at run-time. The default behaviour corresponds to the base class (as in MasterMailSettings, above) and the settings in that code could be hard-coded. Yes, hard coded, just like they are in the config files! When relied on excessively, config files become code. And next time, I will show how with policy settings that fact is even more apparent. So, we might have MasterMailSettings look like this:

    public class MasterMailSettings
    {
        private string mailServer = @"mail.bob.com";
        public virtual string MailServer
        {
            get { return mailServer; }
            set
            {
                if(CanPingMailServer(value))
                mailServer = value;
            }
        }
        private bool CanPingMailServer(string serverAddress)
        {
            // ...
        }
    }

What have we got for this minor piece of heresy? We don't have to maintain a separate config file. We don't have to perform type conversions. It's faster. We can enforce business rules when overriding these values for specific machines. Our code is a lot more comprehensible.  And lastly, there is no framework for our developers to learn to understand what config settings are in play.

But! What about when you really do want to dynamically adjust runtime behaviour? That's when the second level of our config hierarchy comes in. That will deserialise the configurations into a descendant class of the default settings class (as in DevMailSettings, above). Here, the settings can be retrieved from a separate file that is monitor with a file system watcher for example. The client of the config system would ask for an IMailSettings and get a DevMailSettings if on a dev machine. The devmailsettings object would override MasterMailSettings on its MailServer property, but would just return whatever MasterMailSettings defined in all other regards. So, we have encapsulation, run-time control, hierarchical configurations and good performance in the vast majority of cases.

So what should be in the master settings and which should be left for an external file? I guess the answer is - it depends. Does it change between all machines? Is it common to certain classes of machines? Is it modified at runtime? Does it require costly type conversions (such as in DateTime conversions) or does it have complex validation rules? All these things contribute to your final decision, but one thing is for sure. Much less than is commonly configured, needs to be stored in an external file!

Next time I am going to follow this trail a bit further, and distinguish between straight configuration settings, and policy settings. Till then, please post to tell me what you think. I may be way off the mark, but it seems to me that configuration should be kept to an absolute minimum. That's not to say the settings shouldn't be there, just that they shouldn't be externalised.
