\Service directory contains classes, which represent the pattern being used by this microservice to do the work of the service

You can use concrete classes, but always provide an interface file.   Always inject into the controller (used dependency injection).

You can weave in any GOF (Gang of Four) class patterns.



This is simply the place where those classes live, so that the scaffold has a place to go, that is consistent for a developer, to find
the business logic layer of the service.