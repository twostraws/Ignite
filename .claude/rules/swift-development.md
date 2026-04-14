---
paths:
  - "Sources/**/*.swift"
  - "Tests/**/*.swift"
---
# Swift Development Rules

Follow the coding standards in `development-guidelines/00_CORE_RULES/01_CODING_RULES.md`.

## Mandatory

- No force unwraps, no `try!`, no force casts
- Guard clauses for validation, early returns over nesting
- Division safety: check for zero before dividing
- Swift 6 strict concurrency compliance
- All public APIs need DocC comments (see `development-guidelines/00_CORE_RULES/03_DOCC_GUIDELINES.md`)

## Testing (TDD)

Follow `development-guidelines/00_CORE_RULES/09_TEST_DRIVEN_DEVELOPMENT.md`:
- Write failing tests BEFORE implementation
- Test golden path, edge cases, invalid inputs
- Use deterministic test data (no random values)
- Floating point: use accuracy-based assertions, not exact equality