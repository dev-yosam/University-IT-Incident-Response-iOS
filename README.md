University IT Incident Response

This app is for a university IT support technician, not a generic user. 

It is a first-line response tool for real campus jobs: a lecture hall with no Wi-Fi, a projector with no signal, a locked staff account, a lab that cannot print, or exam software that will not open.

It is not a to-do list with different labels. A to-do item is just a task you tick off. An IT incident has a service desk life: it starts in the queue, someone has to accept responsibility, investigation notes stay on the ticket, and the job ends in one of two ways, resolved or handed to a specialist team. Those steps matter because a bad close or a vague escalation wastes the next person's time, and in a teaching space that can mean a class or an exam is stuck.

The stakeholder is the technician at the desk. The screens use their words (accept, work note, resolve, escalate) and the error messages tell them what to do next, not that a validation failed.

How you use it

Open the IT Incident Queue. Pick a ticket to read the report. Accept it if it is still free. On the active incident screen you get sample checks for that category of problem and you can add diagnostic notes. When you are finished, Resolve / Escalate lets you close the job with a summary, or send it to Network Services, Identity and Access, Classroom AV or Desktop Support with a reason.

How the code is organised

Views are the screens. ViewModels call the use cases. The use cases are the business operations, not data helpers: accept, add a work note, resolve, escalate. Models are named after the domain (ITIncident, IncidentWorkNote, EscalationTarget). IncidentRepository only holds the tickets in memory. The rules live in the use cases so a screen cannot skip them.

Rules the app protects

A ticket can only be accepted if it is still queued and not already assigned.
Notes can only be added while the ticket is in progress, and a blank note is rejected.
A ticket cannot be closed without a resolution summary, so the next technician can see what actually worked.
A ticket cannot be escalated without a specialist team and a reason.

How to run

Open ITIncidentResponse.xcodeproj in Xcode, pick the ITIncidentResponse scheme and an iPhone simulator, then press Run. Sample tickets load on launch. There is no login and nothing is stored after you quit. This is a demo, not a live service desk.


