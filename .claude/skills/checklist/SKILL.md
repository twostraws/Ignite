---
name: checklist
description: Create a new feature implementation checklist tracking all TDD phases. Use when starting implementation of an approved feature.
argument-hint: <feature name>
---
Create a new implementation checklist for: $ARGUMENTS

Use the template at `development-guidelines/04_IMPLEMENTATION_CHECKLISTS/TEMPLATE.md`.

Save it to `development-guidelines/04_IMPLEMENTATION_CHECKLISTS/CURRENT_$ARGUMENTS.md` (sanitize the filename).

The checklist should track all phases:
- [ ] Phase 0: Design Proposal
- [ ] Phase 1: Tests (RED)
- [ ] Phase 2: Implementation (GREEN)
- [ ] Phase 3: Refactoring
- [ ] Phase 4: Documentation
- [ ] Phase 5: Quality Gates