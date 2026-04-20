# Report Template for Jira Comment

Use this structure for the report. Omit any section that has no relevant content.

---

## Implementation Report: <ISSUE_KEY>

### Summary

One to three sentences describing what was accomplished at a high level. Connect directly to the ticket's stated goal. Frame as outcomes, not activities.

### What Changed

Group changes by functional area. Each item should be a complete thought understandable by a non-technical stakeholder.

**[Area Name]** (e.g., "Member Verification", "Payment Processing", "API Endpoints")

- Description of what changed and why it matters
- Another change in this area

**[Another Area Name]**

- Description of change

### What Was Added

New capabilities, features, or integrations introduced. Skip this section if nothing new was added.

- New capability and what it enables
- Another addition

### What Was Fixed

Bug fixes or corrections. Frame in terms of the problem that was resolved, not the code that changed. Skip if no fixes.

- Problem that was occurring and how it is now resolved
- Another fix

### What Was Removed or Changed

Breaking changes, deprecations, or behavioral changes to existing functionality. Skip if none.

- What changed and what the impact is

### Impact Areas

List the parts of the system affected by these changes. Helps QA know where to focus testing.

| Area                      | Impact                                            |
| ------------------------- | ------------------------------------------------- |
| e.g., Member Verification | New NPI Registry check added to verification flow |
| e.g., API                 | New endpoint for provider lookup                  |

### Testing Considerations

Specific scenarios QA should verify. Be concrete about inputs and expected outcomes.

- Scenario to test and expected outcome
- Another scenario
- Edge case to watch for

### Configuration and Deployment Notes

New environment variables, feature flags, database migrations, or deployment steps required. Skip if none.

- Note about deployment requirement
