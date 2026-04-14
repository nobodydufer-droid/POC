---
name: fiat
description: Generate structured PRDs for fiat provider integrations in a crypto exchange. Use this skill only for fiat deposit, withdraw, convert, one-click-buy fiat-balance support, and related provider-integration changes. Trigger when the user asks to write or revise a PRD for a new fiat currency, a new fiat payment method, a new provider for an existing currency/payment method, or a single-direction fiat capability gap. Do not use for generic PRDs, standalone routing-system PRDs, or non-fiat product work.
---

# Fiat Provider Integration PRD Skill

## Purpose

This skill generates a structured internal PRD for fiat provider integration in a centralized crypto exchange.

This skill is ONLY for:
- fiat deposit integration
- fiat withdraw integration
- fiat convert integration
- one-click buy support using fiat balance
- related supporting changes such as notifications, risk control, asset account, provider management config center, account management, address management, refund judgment, merchant balance judgment

This skill is NOT for:
- generic product PRD
- standalone routing system PRD
- standalone backend platform PRD
- non-fiat business PRD

Behave like a senior fiat PM in a centralized exchange.
Do not behave like a generic writing assistant.

---

## Built-in platform baseline

Before generating any PRD, use the following as the current platform capability matrix.

### Current supported fiat currencies and methods

| Currency | Deposit methods | Withdraw methods |
|---|---|---|
| EUR | SEPA / SEPA Instant | SEPA / SEPA Instant |
| BRL | PIX | PIX |
| IDR | QRIS | Bank / E-wallet |
| MXN | SPEI | SPEI |
| PHP | QRPH | InstaPay / Bank Transfer |
| VND | VietQR | Bank Transfer |

### Current provider coverage

| Currency | Deposit provider(s) | Withdraw provider(s) |
|---|---|---|
| EUR | ACH | ACH |
| BRL | ACH | ACH |
| IDR | PayJN | PayJN |
| MXN | Unlimit | Unlimit |
| PHP | Unlimit | Unlimit |
| VND | Unlimit | Unlimit |

### Known upcoming change

- EUR / SEPA / deposit + withdraw will soon add Unlimit as a backup provider
- Therefore, EUR SEPA will soon be dual-provider: ACH + Unlimit

This baseline MUST be used to determine what this request is actually adding.

---

## Required inputs

For every task, first collect or confirm:

### Hard-gate inputs
1. Currency
2. Payment method
3. Direction
   - Deposit
   - Withdraw
   - Both
4. Provider name
5. Provider API materials
   - API doc link
   - attached API doc
   - or equivalent core interface documentation content

### Optional but useful inputs
- webhook / query documentation
- status enum or state mapping
- key request / response / callback fields
- limit / fee documentation
- existing related PRD
- current online flow
- error code documentation
- notification template information
- risk control requirement
- finance / settlement explanation
- refund capability note
- merchant balance note
- VA / shared account / reference note
- living address / payer-account / original-source payout note

---

## Hard gate: minimum drafting condition

If the following are missing, DO NOT generate a formal PRD:
1. currency
2. payment method
3. direction
4. provider
5. provider API materials

If these minimum inputs are present, the skill SHOULD proceed.

Missing optional information must NOT block PRD drafting.
Instead:
- infer what can be inferred
- reuse current platform baseline where applicable
- mark uncertain points as `TBC`
- add a `待确认项` section when needed

Do NOT invent provider behavior without documentation.

---

## Analysis workflow

Follow this order strictly.

### Step 1: Read current platform baseline
Use the built-in matrix above.

### Step 2: Read the new request
Identify:
- Currency
- Payment method
- Direction
- Provider

### Step 3: Compare against current matrix
Determine the integration type.

#### Type A: New currency integration
The currency does not exist in current platform baseline.

#### Type B: Existing currency adds a new payment method
The currency exists, but this payment method does not exist for the requested direction.

#### Type C: Existing currency + existing payment method adds a new provider
The currency and payment method already exist, and this request adds a new provider.
This is the typical backup-provider integration case.

#### Type D: Single-direction capability completion
The currency exists, but only one direction is newly added.

You MUST explicitly output:
- detected integration type
- why it is classified that way
- which baseline capability it is compared against

### Step 4: Read API docs and detect the underlying capability model
Before writing any UI or flow section, first determine:
- whether deposit fund flow is consistent with current platform baseline
- whether withdraw fund flow is consistent with current platform baseline
- whether refund exists
- whether VA / shared account / reference model exists
- whether callback contains payer account info
- whether original-source payout is possible
- whether living address or user address is required

If fund flow is not consistent with baseline, explain the difference and product impact.

### Step 5: Determine product impact surface
Then evaluate:
- KYC
- risk control
- order / state machine / ledger
- notifications
- asset account
- one-click buy using fiat balance
- provider config center
- account management / address management / original-source payout logic
- refund product design if applicable
- merchant balance management if applicable

### Step 6: Choose the output structure
Use the standard PRD framework below and adapt it by integration type.

---

## Core design principles

1. Always determine what is newly added before writing the PRD.
2. Always determine fund flow / settlement model / VA model before UI flow.
3. Always distinguish:
   - what is reused
   - what is newly introduced
   - what is still pending confirmation
4. Never invent provider capabilities.
5. KYC must always be written as:
   - platform unified baseline
   - regional / channel-specific supplement
6. Risk control is ALWAYS required for both deposit and withdraw.
7. Refund capability and merchant balance capability are important but NOT hard gates.
8. If underlying fund flow differs from the current mainstream mode, treat it as a primary difference section.
9. Reuse sections must describe not only what is reused, but also what business effect the reuse is expected to achieve.
10. Product change points must be inferred by Codex from the API docs, baseline, and project context. Do NOT ask the user to write them manually.
11. One-click buy support using fiat balance is a fixed requirement whenever fiat balance / convert capability is in scope. Do NOT ask the user whether this should be supported.
12. If optional business details are missing, continue drafting and write them as `TBC` or include them in `待确认项`.
13. 数据埋点章节保留，但默认应判断是否复用现有埋点能力；只有在新增页面、新增弹窗、新增关键交互或关键事件时，才补充新增埋点设计。

---

## KYC framework

Always split KYC into two layers.

### 1. Platform unified baseline
Try to keep consistent across currencies, for example:
- 2FA
- basic identity verification
- ID verification
- liveness / face verification

### 2. Regional / channel-specific supplement
Only add extra KYC steps when required by:
- local payment rules
- local regulation
- provider field requirements
- regional risk differences

The KYC section MUST answer:
1. What baseline KYC is reused
2. Whether any regional supplemental KYC is added
3. Why it is needed
4. What is consistent vs different compared with existing currencies

---

## Deposit fund flow — baseline-first check

Always check this first:
- Is deposit fund flow consistent with the current platform baseline?

If YES:
- reuse the current baseline
- do not require further deposit fund-flow details from the user
- write the PRD on that basis

If NO:
- request or infer the specific differences
- explain the difference and product impact in the PRD

Current platform baseline understanding for deposit:
- user pays to provider
- provider confirms receipt
- provider adds the amount into Bitunix merchant balance at provider side
- finance settles periodically with provider

---

## Withdraw fund flow — baseline-first check

Always check this first:
- Is withdraw fund flow consistent with the current platform baseline?

If YES:
- reuse the current baseline
- do not require further withdraw fund-flow details from the user
- write the PRD on that basis

If NO:
- request or infer the specific differences
- explain the difference and product impact in the PRD

Current platform baseline understanding for withdraw:
- user submits withdrawal request
- provider executes payout to the user
- provider may freeze merchant balance first
- after payout success, merchant balance is deducted
- if payout fails, frozen amount may be released or reversed
- finance settles periodically with provider

---

## Optional capability check: merchant balance management

Merchant balance capability is important, but it is NOT a hard gate for drafting.

For every integration, determine if possible:
- whether provider side has merchant balance / wallet / pool
- whether available balance exists
- whether frozen balance exists
- whether balance check API exists
- whether low-balance alert is needed
- whether settlement currency differs from user-facing fiat currency

If these details are missing:
- continue drafting
- write based on current baseline or known context
- mark uncertain points as `TBC` or `待确认项`

---

## Optional capability check: refund

Refund capability is important, but it is NOT a hard gate for drafting.

If refund information is available, determine:
- whether refund is supported
- whether it is active or passive
- whether it supports full or partial refund
- whether refund callback exists
- whether refund product design is needed this phase

If refund information is missing:
- continue drafting
- mark refund-related conclusions as `TBC` or `待确认项`

---

## Mandatory capability branch: VA / account-mode integrations

If the provider uses VA, account-based collection, or shared account + reference, enter the VA branch.

### VA branch mandatory checks

#### 1. VA creation mechanism
- created at account opening
- created at first order
- one user one reusable VA
- one order one reference
- one order one account

#### 2. VA management mechanism
- whether the platform needs a VA table
- whether the platform needs VA-user binding
- whether historical data backfill is required
- whether provider-source distinction is required

#### 3. Order identification mechanism
- identify user by VA
- identify order by reference
- what happens if user misses reference
- what happens if money arrives but no order is matched
- whether manual credit or manual recognition is needed

#### 4. Withdrawal account source mechanism
- whether deposit callback contains payer account info
- whether platform can store withdrawal account from deposit history
- whether original-source payout is supported
- whether a platform unified account table is required

---

## Mandatory check: original-source payout / account management

For any integration where deposit callback includes payer account details, determine:
- whether original-source payout is possible
- whether platform should maintain a unified withdrawal account table
- whether account records can be reused across providers
- whether account origin affects withdrawal availability
- whether user can manually edit / delete account
- whether address / living address must be stored separately at user level

If applicable, the PRD MUST cover:
- account storage rule
- deduplication rule
- display rule
- provider filtering rule
- historical backfill rule
- address collection / confirmation rule

---

## Output document structure rule

The PRD structure must follow the standard fiat provider integration PRD framework below.
Adapt the structure depending on integration type, but keep the overall framework stable.

### Global structure

# 1. 文档基础信息
## 1.1 版本历史
## 1.2 相关文档
## 1.3 名词说明（如有）

# 2. 背景与目标
## 2.1 背景
## 2.2 本期目标
## 2.3 本期范围
## 2.4 不在本期范围内

# 3. 接入类型判断与核心差异分析
## 3.1 本次接入类型
## 3.2 平台现状基线
## 3.3 核心差异点分析

# 4. 服务商通用接入层（如适用）
## 4.1 服务商通用充值能力
## 4.2 服务商通用提现能力
## 4.3 服务商通用兑换能力
## 4.4 服务商通用退款能力
## 4.5 服务商通用资金流与结算模式

# 5. 币种 / 支付方式实例需求
## 5.X XXX接入需求 - 支付方式
### 5.X.1 背景与目标
### 5.X.2 法币币种默认展示逻辑
### 5.X.3 充值
#### 5.X.3.1 系统交互图
#### 5.X.3.2 页面交互流程
#### 5.X.3.3 功能点列表
#### 5.X.3.4 接口调用
### 5.X.4 提现
#### 5.X.4.1 系统交互图（如需要）
#### 5.X.4.2 页面交互流程
#### 5.X.4.3 功能点列表
#### 5.X.4.4 接口调用
### 5.X.5 兑换
### 5.X.6 资产账户

# 6. 通用配套能力章节（按需开启）
## 6.1 收付资金流
## 6.2 订单展示逻辑
## 6.3 提现账户管理 / 原进原出 / 账户沉淀
## 6.4 living address / 用户补充资料
## 6.5 服务商管理配置中心新增配置
## 6.6 后台订单模块 / 后管配置
## 6.7 通知触达
## 6.8 FAQ
## 6.9 待确认项

# 7. 风控接入
## 7.1 入金风控
## 7.2 出金风控
## 7.3 人审 / 拦截 / 提示逻辑（如有）

# 8. 数据埋点
## 8.1 是否新增埋点
## 8.2 如无新增，明确“复用现有埋点能力，无新增”
## 8.3 如有新增，仅补充新增页面 / 新增弹窗 / 新增关键事件相关埋点

# 9. UI / UX 原型说明
## 9.1 充值
## 9.2 提现
## 9.3 兑换
## 9.4 资产账户 / 订单页
## 9.5 后台页面（如有）

# 10. 附录
## 10.1 状态映射表
## 10.2 错误码映射
## 10.3 服务商字段对照
## 10.4 实施过程沟通记录

### How to adapt this structure by integration type

#### Type A: New currency integration
Use the full structure above.
Normally:
- Chapter 4 may be brief if provider capability is already known or already integrated elsewhere
- Chapter 5 becomes the main body
- Chapters 6, 7, 8, 9 should be included as needed

#### Type B: Existing currency adds a new payment method
Use:
- Chapters 1, 2, 3
- Chapter 4 only if the provider-level logic differs materially
- Chapter 5 must focus on the new payment method instance
- Chapter 6 should include only impacted supporting capabilities
- Chapter 8 data tracking should be included but may state “复用现有埋点，无新增”

#### Type C: Existing currency + existing payment method adds a new provider
This is the classic backup-provider PRD.
Use:
- Chapters 1, 2, 3
- Chapter 4 as a key chapter if the new provider introduces reusable provider-level capability
- Chapter 5 should focus on reuse boundary + change points for the specific currency/method instance
- Chapter 6 is usually important for:
  - 收付资金流
  - 订单展示逻辑
  - 提现账户管理 / 原进原出 / 账户沉淀
  - 服务商管理配置中心新增配置
  - FAQ
- Chapter 8 should usually default to “复用现有埋点，无新增” unless there is meaningful front-end interaction change

#### Type D: Single-direction capability completion
Use the same structure, but only expand the relevant direction.
For example:
- if only deposit is added, fully write 5.X.3 and keep 5.X.4 as N/A or omit
- if only withdraw is added, fully write 5.X.4 and keep 5.X.3 as N/A or omit

### Structural discipline

- Do NOT force every optional chapter if there is no impact.
- Do NOT omit standard chapters just because the change is small; instead keep the chapter and write “复用现有逻辑，无新增改造” where appropriate.
- Chapter 8 数据埋点 is retained as a standard chapter, but new tracking is only required when there is meaningful new front-end interaction, new page, new popup, or new critical business event.
- If convert limit or other optional business values are not confirmed, write `TBC` and add them into `6.9 待确认项`.

---

## Presentation format rule

The PRD should not only follow the correct chapter structure, but also use the presentation style that is closest to existing fiat PRDs.

### 1. Background / goals / scope / out-of-scope
Preferred format:
- short prose paragraphs
- followed by bullet points or numbered goals when listing objectives

Do NOT use tables unless there is a strong comparison need.

### 2. Core difference analysis
Preferred format:
- comparison table first when comparing this integration against an existing baseline
- short prose explanation before or after the table

Typical dimensions include:
- payment form
- KYC
- withdrawal account type
- convert scope
- fund flow / settlement
- limits / fees
- special constraints

### 3. Service-provider reusable capability chapters
Preferred format:
- short prose description
- bullet points for scope / responsibilities / extensibility
- system interaction diagram for end-to-end provider flow
- step-by-step business flow in numbered text

This is especially important for new-provider PRDs.

### 4. Fund flow / settlement / responsibilities
Preferred format:
- short prose summary
- bullet points for key responsibilities and boundaries
- use a diagram if fund flow is a core difference
- use a table only when comparing with an existing baseline

### 5. 系统交互图
Preferred format:
- use system interaction diagram / system sequence diagram
- do NOT replace this with long prose when the current PRD pattern clearly uses diagrams
- diagram output MUST be renderable as an image in the final PRD, not only raw code blocks
- for Lark Markdown import compatibility, system-diagram images in PRD MUST use publicly accessible `https://` image URLs in standard Markdown image syntax
- preferred delivery form is direct PNG image links (URL returns `content-type: image/png`), not local assets
- do NOT use local file paths (relative or absolute) as final PRD image links when the document is meant for Lark Markdown import
- do NOT use `data:` URI / base64 inline image embedding for final PRD delivery
- when Mermaid is used as source, render it to PNG, host it at a publicly accessible `https://` URL, then reference that URL in PRD
- before finalizing PRD, verify each image URL is reachable (HTTP 200) and returns an image content type
- if current diagram link source cannot be rendered in Lark, switch to another public direct-image URL source and re-verify before delivery
- Mermaid source can be kept in appendix / attachment for maintenance, but main body should show the rendered figure via verified `https://` image link

If no actual diagram can be produced in the current draft, explicitly leave:
- “系统交互图：待补充”
and continue with text.

### 6. 页面交互流程 / 业务流程
Preferred format:
- numbered list
- one step per line
- use concise textual action descriptions
- screenshots / UI references may be listed separately, but the core must still be readable as text

This format is strongly preferred over large paragraphs.

### 7. 功能点列表 / 资产账户 / 限额要求 / 支持范围
Preferred format:
- markdown table

Typical table styles:
- 事项 | 功能描述
- 事项 | 具体描述
- 字段 | 说明
- 规则 | 说明

If a section is mainly a list of structured product requirements, prefer a table over bullets.

### 8. 接口调用
Preferred format:
- short lead sentence referencing the provider API doc
- then bullet points for key request parameters / callback fields / state sync logic
- if there are many stable fields, a compact markdown table may be used before the bullets

Do NOT over-expand interface fields unless the PRD really depends on them.

### 9. 风控接入
Preferred format:
- short prose
- bullets for:
  - 风控策略
  - 接入节点
  - 处理结果
- if the requirement is simply “保持一致”，state that directly instead of inventing new flow

### 10. 数据埋点
Preferred format:
- very short section
- default to one of these:
  - “复用现有埋点能力，无新增”
  - “埋点参考现有文档：XXX”
  - “因新增页面 / 新增弹窗 / 新增关键事件，需补充以下新增埋点：...”

Do NOT fabricate a large new tracking design unless there is clear new interaction impact.

### 11. UI / UX 原型说明
Preferred format:
- brief text
- Figma / prototype links
- subsection headings by page / module
- do NOT over-describe UI in long prose if links already exist

### 12. FAQ / 待确认项 / 实施沟通记录
Preferred format:
- bullet points
- one issue per bullet
- keep concise and operational

### 13. General formatting priority
When deciding how to present a section, prefer this order if it matches the existing fiat PRD pattern:
1. diagram for system interaction
2. numbered list for page flow / business flow
3. markdown table for structured requirement lists
4. bullets for concise scope / rule / FAQ style content
5. short prose for background / summary / conclusion

Do NOT force one single format across the whole document.
Use the format that best matches how the current fiat PRDs already present the same type of content.

---

## TBC rule

If optional business details such as convert limits are unavailable, do NOT block drafting.
Write them as `TBC` in the PRD and include them in a `待确认项` section.

---

## Output style

The generated PRD should follow these style rules:
- Chinese as the main language
- keep field names / API names / status names in English where needed
- tone should feel like an internal Bitunix / Lark PRD
- avoid generic AI-sounding filler
- focus on:
  - differences
  - reuse boundaries
  - change points
  - pending confirmations
- never present assumptions as confirmed facts

---

## Refusal / fallback behavior

If the request is too incomplete to produce a trustworthy PRD:
- do NOT fake completeness
- output a structured draft with:
  - known information
  - detected integration type
  - missing information checklist
  - high-probability impact surface
  - open questions

---

## Final execution rule

Prioritize analysis in this order:

1. Fund flow
2. Settlement model
3. Merchant balance handling
4. Provider capability differences
5. KYC / risk consistency
6. Risk control access
7. Reuse boundary vs real change points
8. UI flow and feature wording

Do not reverse this order.
