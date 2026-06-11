# Misc

我留着但很少使用的工具。

- **[git-guardrails-claude-code](./git-guardrails-claude-code/SKILL.md)** — 设置 Claude Code 钩子，在危险 git 命令（push、reset --hard、clean 等）执行之前阻止它们。
- **[guard-dangerous-ops-claude-code](./guard-dangerous-ops-claude-code/SKILL.md)** — 设置 Claude Code PreToolUse 钩子，在执行前拦截不可逆的危险 Bash 操作：致命的（rm -rf /、写块设备、mkfs）直接拒绝，危险但常见的（rm -rf 某目录、sudo、kill -9、publish、curl|sh 等）弹出确认让用户 double check 后才放行。git 命令交给 git-guardrails-claude-code。
- **[limit-commit-size](./limit-commit-size/SKILL.md)** — 安装 git 钩子，强制每次 commit / push 的改动少于 1000 行，超限即拒绝并提示如何拆分（agent、人工、其他工具一律生效）。
- **[migrate-to-shoehorn](./migrate-to-shoehorn/SKILL.md)** — 将测试文件从 `as` 类型断言迁移到 @total-typescript/shoehorn。
- **[scaffold-exercises](./scaffold-exercises/SKILL.md)** — 创建带有章节、问题、解答和讲解的练习目录结构。
- **[setup-pre-commit](./setup-pre-commit/SKILL.md)** — 设置带有 lint-staged、Prettier、类型检查和测试的 Husky 预提交钩子。
