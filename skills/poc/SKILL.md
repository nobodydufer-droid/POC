---
name: poc
description: Generate minimal fiat provider POC scenarios, callback/query validation matrices, and Lark-ready Markdown tables when the user asks for POC cases, provider interface validation, deposit/withdraw API connectivity checks, or converting provider docs into a smallest-possible test matrix. Do not use this skill for full PRDs, platform product design, routing design, UI/UX design, or cross-provider comparisons unless the user explicitly asks.
---

# poc

## Purpose
This skill generates **minimal POC validation scenarios** for fiat provider integrations.

Its default job is:
- read the user’s provider context and any provider/API docs they give;
- identify only the scenarios required to validate that the provider deposit / withdrawal interfaces can be connected and run through successfully;
- output a **single full Markdown document** that can be copied directly into Lark;
- keep the scope strictly at the **POC level**, not PRD level.

This skill is optimized for fiat deposit/withdraw provider integrations such as QR payment, bank transfer, e-wallet, virtual account, payout, and webhook/query-based flows.

## When to trigger
Trigger this skill when the user asks for any of the following:
- “做 POC 场景” / “列 POC 场景” / “补充 POC case”
- provider deposit / withdraw API minimal validation cases
- callback success/failure/query compensation validation matrix
- converting provider docs into test scenarios
- minimal integration verification checklist
- Lark-ready Markdown POC tables for provider connectivity verification

## When NOT to trigger
Do **not** use this skill when the user is asking for:
- a full PRD or BRD
- front-end page design
- admin/backoffice feature design
- routing strategy design
- cross-provider comparison or provider selection analysis
- business process optimization beyond minimal API validation
- user-facing copywriting unless the user explicitly asks

If the request is broader than POC, either:
1. answer only the POC portion, or
2. explicitly state which part is POC and which part is outside this skill’s default scope.

## Core principles
Always follow these rules unless the user explicitly overrides them.

### 1. POC means minimum viable verification
POC exists to verify that the provider interface can be connected and the critical status transitions can be observed.

Default POC scope includes only:
- create order success/failure
- callback success/failure
- query success/failure or compensation query
- status mapping validation
- amount / currency / payment method validation
- required field validation
- basic timeout / duplicate callback / mismatch handling

Default POC scope excludes:
- Bitunix platform product design
- non-POC backoffice requirements
- UI polish
- funnel / conversion optimization
- multi-provider routing
- marketing / operations process
- generalized compliance framework design

### 2. Never block the output on missing details
If information is incomplete, do **not** refuse or stop.

Instead:
- produce the smallest valid POC matrix from known information;
- state assumptions clearly;
- put unknown items into a dedicated “待确认项 / Open Questions” section.

### 3. Default to existing platform fund flow unless user says otherwise
For fund flow and settlement assumptions:
- if the user does **not** explicitly say deposit fund flow differs from the current platform flow, assume it is reused;
- if the user does **not** explicitly say withdrawal fund flow differs from the current platform flow, assume it is reused;
- do not make fund-flow detail a hard prerequisite for output.

### 4. Optional information must not be treated as hard gates
The following are useful but **not required** to start output:
- provider status enum / state machine doc
- key request fields
- key response fields
- key callback fields
- merchant balance capability details
- settlement-cycle details

If any of these are missing:
- proceed with a generic minimal POC structure;
- add the unknown parts to “待确认项”.

### 5. Stay provider-specific
Unless the user explicitly asks otherwise:
- only discuss the provider in scope;
- do not bring in competing providers;
- do not compare against other service providers;
- do not add platform-side routing logic.

### 6. Use concise, test-oriented language
Write like an experienced product manager / test designer preparing a provider connectivity check.

Avoid:
- fluffy explanation
- generic consulting language
- long prose paragraphs
- repeating the obvious

Prefer:
- scenario-oriented wording
- direct expected-result statements
- compact, operational language

## Required output format
Always output in **one complete Markdown block**, not fragmented sections.

The output must:
- be directly copyable into Lark;
- use standard Markdown headings and tables;
- avoid screenshots, images, or pseudo-table formatting;
- avoid splitting the answer into many separately copyable pieces unless the user explicitly asks.

Unless the user requests another structure, use this template:

1. `# <provider/payment-method> POC场景`
2. `## 1. POC原则`
3. `## 2. 假设与待确认项`
4. `## 3. 充值 POC 场景`
5. `## 4. 提现 POC 场景`
6. `## 5. 边界与异常场景`
7. `## 6. P0优先执行项`

## Table style rules
Use Markdown tables by default.

Recommended table columns:
- `模块`
- `场景ID`
- `场景名称`
- `前置条件`
- `触发方式`
- `预期结果`
- `备注`

If the user already established another table style in the conversation, follow that style instead.

## Scenario generation logic
When generating scenarios, use the following decision rules.

### Deposit baseline scenarios
Unless explicitly out of scope, include:
1. create deposit order success
2. create deposit order failure
3. provider success callback received and recognized
4. provider failure callback received and recognized
5. create success but callback not received -> query compensation path
6. duplicate callback / repeated notification
7. callback/query returns final success -> can determine successful completion
8. callback/query returns final failure -> can determine failed completion
9. returned amount differs from requested amount
10. required field missing / invalid format
11. unsupported currency / payment method / amount precision or out-of-range amount

### Withdraw baseline scenarios
Unless explicitly out of scope, include:
1. create withdrawal order success
2. create withdrawal order failure
3. provider success callback received and recognized
4. provider failure callback received and recognized
5. create success but callback not received -> query compensation path
6. duplicate callback / repeated notification
7. final success status handling
8. final failure status handling
9. returned amount differs from requested amount
10. required payout account field missing / invalid format
11. unsupported currency / payment method / amount precision or out-of-range amount

### Boundary / exception scenarios
Add when relevant:
- min amount
- max amount
- below min
- above max
- no decimal / decimal precision error
- invalid account identifier
- invalid bank code / wallet id / reference code
- expired QR / expired payment window
- mismatched payment reference
- user paid after expiry
- status remains processing beyond expected window
- provider HTTP success but business status failure
- provider callback signature / auth failure if callback verification is mentioned
- idempotency or repeated create-order submission when the provider supports or requires it

## Status handling rules
If provider docs include status enums, map scenarios to the actual provider statuses.
If provider docs do not include status enums, use a generic lifecycle:
- Created
- Processing
- Success / Completed
- Failed / Declined
- Expired

Never invent a detailed state machine and present it as fact.
If uncertain, mark it as assumption.

## How to handle provider documentation
If the user provides provider docs or excerpts:
1. extract only the fields/statuses relevant to POC;
2. ignore unrelated PRD material;
3. prioritize:
   - create order interface
   - callback interface
   - query interface
   - key request constraints
   - key response fields
   - status enums
   - amount/account validation rules
4. transform doc detail into testable scenarios.

If the provided material mixes provider integration requirements with platform feature design:
- keep only the provider-connectivity validation portion in the POC output;
- exclude non-POC items by default.

## Default writing behavior
When replying with the final deliverable:
- do not say “以下是思路” unless the user asked for reasoning;
- do not over-explain why something is or is not POC;
- directly provide the finished Markdown.

If assumptions are necessary, express them briefly, e.g.:
- `默认假设：入金资金流复用当前平台现有逻辑。`
- `默认假设：提现资金流复用当前平台现有逻辑。`
- `待确认：服务商是否提供主动查询接口。`

## Quality bar
A good output from this skill should be:
- compact
- provider-specific
- clearly within POC scope
- structurally complete
- directly usable by product / QA / dev for initial verification

A bad output from this skill would:
- drift into full product design
- introduce unrelated providers
- require too many missing inputs before producing anything
- be verbose and non-operational
- output scattered text instead of one full Markdown document
