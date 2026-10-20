---
name: archimate-excalidraw
description: "Use when: creation of archimate diagram in the excalidraw style."
---

# ArchiMate Excalidraw Skill

## Purpose

This skill is used to create diagrams with ArchiMate notation in Excalidraw format.
It defines the visual rules, color palette, and the set of reusable elements to use in diagrams.

## ArchiMate version and reference

This skill is based on the ArchiMate 3.2 specification.

Reference PDF:
[ArchiMate 3.2 Specification Reference Cards -- Personal PDF Edition](https://www.opengroup.org/sites/default/files/docs/downloads/n221p.pdf)

## What this skill does

- Creates ArchiMate-aligned diagrams in Excalidraw style.
- Reuses the sprites in the `sprites` directory as the source of truth for shapes.
- Applies consistent layer colors so diagrams remain readable and homogeneous.
- Restricts element usage to the supported elements listed below.

## Allowed elements (from sprites)

Critical rule for sprite usage:
- Each sprite is a complete visual group and MUST be reused as-is.
- NEVER rebuild an element manually from partial primitives.
- You MUST reuse ALL parts from the sprite group: base shape + icon + text.
- This is ABSOLUTELY mandatory because the final ArchiMate symbol is intentionally complex, and this complexity is the core value of this skill.
- If only part of a sprite is reused, the result is invalid for this skill.

Use only the elements defined by these sprite files:

- `motivation-driver.excalidraw`: ArchiMate Motivation element `Driver`. _Represents an external or internal condition that motivates an organization to define its goals and implement the changes necessary to achieve them._ Replace the text "Driver name" with the actual name of the driver in your diagram.
- `motivation-requirement.excalidraw`: ArchiMate Motivation element `Requirement`. _Represents a statement of need that must be realized by a system, or other work product._ Replace the text "Requirement text" with the actual text of the requirement in your diagram.
- `motivation-goal.excalidraw`: ArchiMate Motivation element `Goal`. _Represents a high-level statement of intent, direction, or desired end state for an organization and its stakeholders._ Replace the text "Goal text" with the actual text of the goal in your diagram.
- `motivation-outcome.excalidraw`: ArchiMate Motivation element `Outcome`. _Represents an end result, effect, or consequence of a certain state of affairs._ Replace the text "Outcome text" with the actual text of the outcome in your diagram.
- `motivation-value.excalidraw`: ArchiMate Motivation element `Value`. _Represents the relative worth, utility, or importance of a business service, product, or outcome._ Replace the text "Value text" with the actual text of the value in your diagram.
- `motivation-stakeholder.excalidraw`: ArchiMate Motivation element `Stakeholder`. _Represents the role of an individual, team, or organization (or classes thereof) that represents their interests in the effects of the architecture._ Replace the text "Stakeholder name" with the actual name of the stakeholder in your diagram.
- `strategy-capability.excalidraw`: ArchiMate Strategy element `Capability`. _Represents an ability that an active structure element, such as an organization, person, or system, possesses._ Replace the text "Capability name" with the actual name of the capability in your diagram.
- `strategy-value-stream.excalidraw`: ArchiMate Strategy element `Value Stream`. _Represents a sequence of activities that create an overall result for a customer, stakeholder, or end user._ Replace the text "Value Stream text" with the actual text of the value stream in your diagram.
- `business-function.excalidraw`: ArchiMate Business element `Business Function`. _Represents a collection of behavior based on a chosen set of criteria, such as required resources, competences, knowledge, or business objects._ Replace the text "Function name" with the actual name of the business function in your diagram.
- `business-process.excalidraw`: ArchiMate Business element `Business Process`. _Represents a behavior element that groups behavior based on a chosen set of criteria, such as required resources, competences, knowledge, or business objects._ Replace the text "Process name" with the actual name of the business process in your diagram.
- `application-component.excalidraw`: ArchiMate Application element `Application Component`. _Represents a modular, deployable, and replaceable part of a software system that encapsulates its behavior and data._ Replace the text "Application component name" with the actual name of the application component in your diagram.
- `application-interface.excalidraw`: ArchiMate Application element `Application Interface`. _Represents a point of access where an application service is made available to a user, another application component, or a node._ No text need for application interface.
- `technology-artifact.excalidraw`: ArchiMate Technology element `Artifact`. _Represents a physical piece of data or information that is used or produced in a software development process, or by deployment and operation of a system._ Replace the text "Artifact name" with the actual name of the technology artifact in your diagram.

If a requested concept is not represented by one of these sprites, do not invent a new shape in this skill and use a simple rectangle with a text and transparent background color instead.

## Relationships and associations

ArchiMate Relationship elements. _Represents various types of associations between elements, such as serving, specializing, and other relationships._ Select the appropriate association type from the list of available associations in the sprite file.
- `relations-association.excalidraw`: ArchiMate Relationship element `Association`. _Represents a generic relationship between two elements._
- `relations-serving.excalidraw`: ArchiMate Relationship element `Serving`. _Represents a relationship in which one element provides a service to another element._
- `relations-realization.excalidraw`: ArchiMate Relationship element `Realization`. _Represents a relationship in which one element realizes or implements another element._
- `relations-specialization.excalidraw`: ArchiMate Relationship element `Specialization`. _Represents a relationship in which one element is a specialized version of another element._
- `relations-composition.excalidraw`: ArchiMate Relationship element `Composition`. _Represents a relationship in which one element is composed of one or more other elements._
- `relations-aggregation.excalidraw`: ArchiMate Relationship element `Aggregation`. _Represents a relationship in which one element is an aggregate of one or more other elements._
- `relations-assignment.excalidraw`: ArchiMate Relationship element `Assignment`. _Represents a relationship in which one element is assigned to another element._

Allowed relationships between elements and types are defined in the ArchiMate specification. Use only the associations that are valid for the elements you are connecting. Here is a list of the allowed relationships between the elements defined in this skill:
- Driver → Outcome: 
  - Association type: Association
- Outcome → Requirement:
  - Association type: Realization
- Outcome → Goal:
  - Association type: Realization
- Outcome → Value:
  - Association type: Association
- Goal → Stakeholder:
  - Association type: Association
- Stakeholder → Value Stream:
  - Association type: Association
- Value Stream → Value:
  - Association type: Realization
- Value Stream → Capability:
  - Association type: Serving
- Application Component → Application Interface:
  - Association type: Association

Mandatory checklist for each relationship:
- Relationship type matches the allowed mapping above.
- Arrow style matches the relationship sprite (for example realization vs association).
- `startBinding.elementId` points to the source element.
- `endBinding.elementId` points to the target element.
- Relationship label is bound to the arrow via `boundElements` and `containerId`.

## Colors palette

In this skill, we use a specific color palette to maintain consistency and visual appeal in the diagrams. The colors are defined as follows:
- **Motivation level**: 
  - Color: #d0bfff (ArchiMate motivation purple)
  - Usage: Represents the motivation level of elements in the diagram.
- **Strategy level**: 
  - Color: #ffd8a8 (ArchiMate strategy orange)
  - Usage: Represents the strategy level of elements in the diagram.
- **Business level**: 
  - Color: #ffec99 (ArchiMate business yellow)
  - Usage: Represents the business level of elements in the diagram.
- **Application level**:
  - Color: #a5d8ff (ArchiMate application blue)
  - Usage: Represents the application level of elements in the diagram.
- **Technology level**:
  - Color: #b2f2bb (ArchiMate technology green)
  - Usage: Represents the technology level of elements in the diagram.
