Got it ✅  here’s the updated and **clean public-safe version** of
# 🧩 Problem  Day 1

### Managing Multiple Git Accounts on One System

**Date:** November 1, 2025
**Category:** Git / SSH / DevOps Workflow
**Tags:** github, ssh, zsh, automation, multi-account

---

## Background

As part of my DevOps and engineering workflow, I manage multiple GitHub accounts one for personal projects and another for professional work.

Initially, using both accounts on the same macOS machine caused a lot of confusion:
commits would sometimes appear under the wrong identity, SSH connections failed unpredictably, and switching between accounts meant constantly editing configuration files.

It was clear this was not sustainable, especially as the number of repositories grew.

---

## The Problem

When multiple GitHub accounts are configured on a single system:

* The SSH agent often picks up the **wrong private key**.
* Git commits might use an incorrect username or email.
* Pushes can fail with authentication errors because the wrong key is used.

Typical errors looked like this:

```
git push origin main
ERROR: Permission denied (publickey).
fatal: Could not read from remote repository.
```

Manually switching keys and updating Git configuration for each repository wasn’t efficient.
I needed a **seamless, automated solution** that could identify which account to use
based on the directory I was working in.

---

## Thought Process

I tried the usual options first:

| Attempt                           | Description                                  | Drawback                         |
| --------------------------------- | -------------------------------------------- | -------------------------------- |
| Editing `~/.ssh/config` manually  | Added multiple host aliases for each account | Tedious to maintain              |
| Using global Git config           | Applied one identity system-wide             | Broke multi-account isolation    |
| Configuring per-repo Git settings | Updated identity inside each repository      | Repetitive and prone to mistakes |
| Running multiple SSH agents       | Started and stopped different agents         | Too fragile for daily workflow   |

I wanted something **automatic and context-aware**
a setup that detects which account should be used based on the current folder,
without requiring me to manually intervene.

---

## The Solution

To solve this, I wrote a small automation utility called **`ghprofile`**,
a directory-aware GitHub profile switcher.

This script manages multiple SSH keys and Git identities,
automatically applying the correct configuration whenever I switch directories or open a new terminal.

It integrates directly with my **zsh shell** and runs silently in the background.

**Reference:**
The script and setup guide are available at
[`docs/ghprofile-setup.md`](../docs/ghprofile-setup.md)

---

## How It Works

* Each GitHub profile (e.g., personal or work) has its own SSH key and identity.
* The script maintains a simple mapping of which profile to use in each directory.
* When I move between repositories, the terminal automatically applies the correct Git configuration and SSH key.
* This mapping is stored locally, so once configured, it works across all sessions.

In short, it detects the *context* where I am and activates the correct account.

---

## Integration

To make it completely seamless, I added a **zsh hook** that runs automatically
whenever I navigate to a different project directory.

This hook calls the `ghprofile` utility, which applies the appropriate SSH key and Git identity
for that directory’s associated GitHub account.

No manual switching, no SSH restarts it just works.

---

## Why This Approach Works

| Goal                              | How It’s Achieved                                 |
| --------------------------------- | ------------------------------------------------- |
| Manage multiple GitHub identities | Each account has its own SSH key and Git identity |
| Automatic switching               | The shell hook detects directory context          |
| Isolation & security              | Uses `IdentitiesOnly` to restrict SSH key usage   |
| Scalability                       | Add new profiles easily without complex setup     |
| Zero manual config                | No need to edit global or per-repo Git settings   |

---

## Results

After setting this up:

* Each repository automatically uses the correct GitHub account.
* Commits always show the right author and email.
* SSH authentication issues disappeared completely.
* Switching between personal and work repos became effortless.

It’s a small automation, but it makes a huge difference in everyday productivity
especially when juggling multiple contexts.

---

## Key Takeaways

1. Managing multiple GitHub accounts doesn’t need to be messy.
2. Small automations, when well-designed, save hours of repetitive work.
3. Context-aware scripts are invaluable for multi-environment engineers.
4. Investing time in shell automation pays off every single day.

---
