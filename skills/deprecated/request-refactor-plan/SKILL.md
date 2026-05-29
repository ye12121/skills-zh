---
name: request-refactor-plan
description: 通过用户访谈创建一份带有微小提交的详细重构计划，然后归档为 GitHub Issue。当用户希望规划一次重构、创建重构 RFC，或把一次重构拆分成安全的增量步骤时使用。 / Create a detailed refactor plan with tiny commits via user interview, then file it as a GitHub issue. Use when user wants to plan a refactor, create a refactoring RFC, or break a refactor into safe incremental steps.
---

当用户想创建一份重构请求时，将调用此 skill。你应当走完下方步骤。如果某些步骤你认为不必要，可以跳过。

1. 让用户给出一段长而详细的问题描述，以及任何潜在的解决方案想法。

2. 探索仓库以验证他们的断言并理解代码库当前状态。

3. 询问他们是否考虑过其他选项，并向他们呈现其他选项。

4. 就实现细节访谈用户。极尽详尽彻底。

5. 把实现的确切范围敲定下来。理清你计划改什么、不打算改什么。

6. 查看代码库以检查该区域的测试覆盖。如果测试覆盖不足，问用户对测试的计划是什么。

7. 把实现拆成一份微小提交的计划。记住 Martin Fowler 的建议："make each refactoring step as small as possible, so that you can always see the program working."

8. 用重构计划创建一个 GitHub Issue。Issue 描述使用以下模板：

<refactor-plan-template>

## Problem Statement

The problem that the developer is facing, from the developer's perspective.

## Solution

The solution to the problem, from the developer's perspective.

## Commits

A LONG, detailed implementation plan. Write the plan in plain English, breaking down the implementation into the tiniest commits possible. Each commit should leave the codebase in a working state.

## Decision Document

A list of implementation decisions that were made. This can include:

- The modules that will be built/modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

## Testing Decisions

A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (i.e. similar types of tests in the codebase)

## Out of Scope

A description of the things that are out of scope for this refactor.

## Further Notes (optional)

Any further notes about the refactor.

</refactor-plan-template>
