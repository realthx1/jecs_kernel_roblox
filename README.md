# jecs_kernel_roblox

**A collection of utilities for the jecs_kernel package and Roblox.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)
[![pesde](https://img.shields.io/github/v/tag/realthx1/jecs_kernel_roblox?&style=for-the-badge&label=pesde)](https://pesde.dev/packages/realthx1/jecs_kernel_roblox)

---

## Installation

Using [**pesde**](https://pesde.dev/):

```bash
pesde add realthx1/channels -t roblox
```

## Usage

- [/examples/quickstart.luau](./examples/quickstart.luau) - simple example which showcases the essentials.
- Public API - Use a language server to see doc comments. All public code is documented.

> For jecs_kernel's usage, refer to its own examples and code documentation.

## Contents

- Default schedules and SchedulesPlugin for their setup.
- Default app runner for the schedules.
- TimePlugin and RealTime, FixedTime and SyncTime resources for tracking different elapsed time.
- ChannelPlugin and a Channel component for updating channels from `realthx1/channels`.

### Schedule Order

Startup schedules are ran once at app run.

- PreStartup
- Startup
- PostStartup

Update schedules are ran at every RunService heartbeat.

- First
- PreUpdate
- Update
- PostUpdate
- Last

Additionally, between the PreUpdate and Update schedule a set of fixed timestep schedules are ran 0 or more times.

- FixedFirst
- FixedPreUpdate
- FixedUpdate
- FixedPostUpdate
- FixedLast

Each RunService event has its own schedule. Heartbeat event schedule is an alias to the Update schedule.

- PreAnimation
- PreSimulation
- PostSimulation
- Heartbeat
- PreRender (only runs on client)
