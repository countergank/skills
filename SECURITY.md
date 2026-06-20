# Security Policy

## Vulnerability Reporting

If you discover a security vulnerability in any skill within this repository, please report it responsibly.

- **Contact**: Open a private GitHub issue or email the repository maintainers.
- **Scope**: Reportable issues include executable code injection, credential leakage, supply-chain risks, and malicious patterns in skill templates or scripts.
- **Response**: We aim to acknowledge reports within 48 hours and provide a remediation timeline within one week.
- **Disclosure**: Please do not publicly disclose vulnerabilities until a fix is available.

## Scanning Policy

Every skill **must** pass a SkillSpector scan before merge. Enforcement is automated via GitHub Actions — the `security-scan` workflow runs on every PR and push to protected branches.

- **Install path**: Users install skills via `npx skills add countergank/skills`. Scanning is a pre-merge requirement, not a user-facing step.
- **Scan command**: `./scripts/scan.sh skills/<name> --format json`
- **Batch scan**: `./scripts/scan-all.sh --format json` scans all skills in the repository.
- **CI enforcement**: The `security-scan` workflow runs automatically on every pull request and push to `main`/`develop`. Results appear in the GitHub Security → Code Scanning tab.
- **No bypass**: Skipping the scan is not permitted for production or organizational use.

## Branch Protection

The `main` and `develop` branches require the **`security-scan`** status check to pass before merge.

### Configuration (repository admin)

1. Go to **Settings → Branches → Add branch protection rule**
2. Set branch name pattern to `main` (repeat for `develop`)
3. Check **"Require status checks to pass before merging"**
4. Search and select **`security-scan`**
5. Check **"Require branches to be up to date before merging"**
6. Do **NOT** check "Include administrators" during rollout

> **Note**: The check must have run at least once on the branch before it appears in the status check search. Open a PR or push to the branch first if the check is not yet listed.

## SkillSpector Detection Coverage

SkillSpector analyzes skill content for the following risk categories:

- **Executable code**: Detects embedded scripts, shell commands, and code execution patterns that could run unexpectedly.
- **Suspicious patterns**: Identifies prompt injection vectors, data exfiltration attempts, and social engineering content.
- **Supply-chain risks**: Flags references to unverified packages, external URLs, and dependency chains that may introduce vulnerabilities.
- **Credential exposure**: Detects hardcoded secrets, API keys, tokens, and authentication material.
- **Permission escalation**: Identifies skills that request elevated access or modify system configuration.

### Limitations

SkillSpector is a static analysis tool. It cannot detect:
- Runtime behavior that depends on external state
- Socially engineered content that appears benign
- Novel attack vectors not yet encoded in detection rules

Manual review is recommended for any skill flagged by SkillSpector, and for all third-party skills before installation.

## Remediation Guidelines

When SkillSpector flags a skill, follow these steps:

1. **Review the report**: Examine each flagged issue for severity and context.
2. **Determine if it is a false positive**: Some patterns are legitimate (e.g., code templates). Document the justification.
3. **Remediate confirmed issues**:
   - Remove or sanitize executable code that runs without user consent.
   - Replace hardcoded credentials with environment variable references.
   - Update external URLs to point to verified, trusted sources.
   - Remove or scope down permission requests.
4. **Re-scan**: Run `scan.sh` again to confirm the issue is resolved.
5. **Escalation**: If an issue cannot be remedated (e.g., the skill inherently requires risky behavior), the skill should be:
   - Moved to an untrusted category
   - Documented with explicit warnings
   - Rejected if the risk outweighs the value

### Rejection Criteria

A skill should be rejected if it:
- Contains confirmed malicious code or intent
- Cannot pass a scan after two remediation attempts
- Requires system-level access without clear justification
- Exfiltrates data or communicates with unverified external services

## Trust Model

Skills installed via `npx skills add countergank/skills` inherit the repository's trust level.

| Level | Criteria | Scan Required | Manual Review |
|-------|----------|---------------|---------------|
| **Verified** | Authored by repository maintainers, passes scan, reviewed | Yes | Initial only |
| **Community** | Authored by contributors, passes scan, peer-reviewed | Yes | Per change |
| **Untrusted** | External or third-party, not yet reviewed | Yes | Required before install |

### Third-Party Skill Handling

- External skills must be placed in a designated `external/` or `third-party/` directory.
- They must pass a full SkillSpector scan before any installation.
- They should not be mixed with verified skills in automated install flows.
- The trust level should be clearly indicated in the skill's frontmatter or registry entry.

### Organizational Skills

Project-level skills (under `skills/`) are considered **Verified** once they pass the scan and are merged into the main branch.
