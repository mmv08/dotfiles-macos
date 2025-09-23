# Branch Review Command

Perform a critical and context-aware code review comparing the current branch to `$ARGUMENTS`. Your primary goal is to identify substantive issues related to correctness, security, performance, and long-term maintainability.

### Guiding Principles

- **Prioritize by Impact**: Focus your analysis in this order: **1. Correctness & Security**, **2. Performance & Resource Usage**, **3. Architecture & Maintainability**, **4. Style & Convention**. Don't get lost in minor stylistic issues if major logical flaws exist.
- **Infer, Don't Assume**: Your source of truth for project standards (e.g., coding style, error handling patterns, architectural choices) is the **existing code in the base branch**, not generic "best practices." Flag deviations from established patterns within the project.
- **Question the "Why"**: Don't just review the code as written. Analyze the _intent_ based on commit messages and the problem being solved. Assess if the chosen solution is proportional to the problem. Is there a simpler, more direct way to achieve the same goal?

### Phase 1: Context and Intent Analysis

1.  **Establish Technical Context**: From the diff, identify the primary language(s), framework(s), and key libraries. This context informs the rest of your review.
2.  **Determine Change Footprint**:
    - What is the overall size and scope of the change (e.g., minor bugfix, new feature, major refactoring)?
    - What are the critical files or modules being modified? Note any changes to core logic, public APIs, or configuration.
    - Identify any dependency changes (additions, removals, version bumps) and consider their potential stability and security implications.
3.  **Infer Author's Intent**:
    - Synthesize the commit messages and code changes to determine the core problem being solved.
    - Evaluate if the solution directly and effectively addresses that problem without introducing unnecessary scope.

### Phase 2: In-Depth Code Review

**1. Correctness and Reliability**

- **Logic Flaws**: Scrutinize the core logic. Are there flawed assumptions, incorrect calculations, or logical fallacies?
- **Edge Cases**: Identify potential edge cases, off-by-one errors, or race conditions that the new code might not handle.
- **Error Handling**: Does the error handling align with the project's existing patterns? Are errors swallowed, or are they handled gracefully? Is resource cleanup (e.g., file handles, network connections) properly managed in both success and failure paths?
- **Immutability and State**: Are there any unintended mutations of state? Is state management handled in a predictable way?

**2. Security**

- **Input Validation**: Scrutinize any new code that processes external input (from users, APIs, files). Is it properly sanitized and validated to prevent common vulnerabilities (e.g., SQL Injection, XSS, Path Traversal)?
- **Secrets and Configuration**: Check for hard-coded secrets, keys, or sensitive configuration. Ensure any changes align with the project's secret management strategy.
- **Authentication & Authorization**: If the changes touch auth-related logic, verify that checks are not weakened or bypassed.

**3. Performance and Resource Management**

- **Algorithmic Efficiency**: Are there any obviously inefficient algorithms or data structures for the task at hand (e.g., using $O(n^2)$ loops where $O(n \log n)$ is feasible)?
- **Resource-Intensive Operations**: Identify potential performance bottlenecks. Pay close attention to database queries (N+1 regressions), file I/O, network requests, and memory allocation in tight loops.
- **Concurrency**: If asynchronous or multi-threaded code is present, analyze for potential deadlocks, race conditions, or inefficient resource contention.

**4. Architecture and Maintainability**

- **Adherence to Project Patterns**: Does the change follow the established architectural patterns of the codebase (e.g., repository pattern, service layers, dependency injection)? Flag significant deviations.
- **Cohesion and Coupling**: Does the new code have a single, clear responsibility? Is it loosely coupled with other parts of the system, or does it create unnecessary dependencies?
- **Clarity and Readability**: Is the code unnecessarily complex or "clever"? Could a future developer easily understand and modify it? Is the naming of variables and functions clear and unambiguous?
- **Code Duplication**: Identify if the changes introduce significant code duplication that could be refactored into a shared function or module.

**5. Testing**

- **Test Quality**: Review the tests themselves. Do they meaningfully assert the desired behavior and cover failure cases? Are they isolated and free of side effects?
- **Test Coverage**: Assess if the tests provide reasonable coverage for the new logic, especially for critical paths and edge cases. It's not about the percentage but the quality of the coverage.

### Phase 3: Final Checks

- **Documentation**: Does this change require updates to user documentation, API specifications (e.g., OpenAPI/Swagger), or internal architectural diagrams? Are complex parts of the code reasonably commented?
- **Quick Sanity Checks**:
  - No commented-out code blocks.
  - No debugging artifacts (`console.log`, `print`, etc.).
  - No unresolved `TODO` or `FIXME` comments that should be addressed by this change.
  - Breaking changes are clearly noted in commit messages or documentation.
