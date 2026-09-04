# Jet Engine Cycle Analysis

A parametric turbine-engine cycle simulator written in MATLAB. Given a set of
flight conditions and engine design parameters, it marches the working fluid
through each engine component and reports the station-by-station thermodynamic
state along with overall performance: specific thrust, thrust-specific fuel
consumption (TSFC), work terms, and temperature/pressure at every station.

Built for the **AE4451 – Jet and Rocket Propulsion** term project: design and
compare engine cycles (ramjet / turbojet / turbofan, with optional bleed
cooling and afterburning) that meet a commercial airliner's thrust
requirements at two flight conditions while minimising fuel consumption.

## The problem

The engine must deliver a required specific thrust at two design points, while
staying within turbine-temperature, afterburner-temperature and bleed limits:

| Flight condition | T_a (K) | p_a (kPa) | Mach | Required specific thrust (kN·s/kg) |
|---|---|---|---|---|
| Ground roll (static) | 285 | 100 | 0.00 | 2.8 |
| High-altitude subsonic cruise | 220 | 29 | 0.86 | 0.869 |

The goal is to pick a cycle and the design parameters (`Prc`, `Prf`, bypass
ratio, bleed ratio, and the main/afterburner fuel-air ratios) that hit those
thrust targets with the lowest TSFC.

## How it works

`main.m` loops over the flight conditions and, for each, pushes the flow
through the components in order. Each component takes the incoming stagnation
state plus its design parameters and returns the exit state:

```
ambient ─▶ diffuser ─▶ compressor ─▶ combustor ─▶ turbine (+afterburner) ─▶ nozzle ─▶ exhaust
   a          02           03            04              05 / 06                e
```

- **Diffuser** — ram compression from flight Mach, with MIL-E-5008B ram
  pressure recovery for supersonic inlets.
- **Compressor** — modelled with polytropic efficiency; returns work per unit
  core-air flow.
- **Combustor** — heat addition to the turbine-inlet temperature, with the
  bleed-cooling correction raising the allowable `Tmax`, and reports `fmax`.
- **Turbine + afterburner** — extracts the compressor work; optional
  afterburner reheat before the nozzle.
- **Core nozzle** — expands to ambient pressure, giving exhaust velocity,
  specific thrust and TSFC.

State numbering follows the project handout (`02` diffuser exit, `03`
compressor exit, `04` burner exit, `05` turbine exit, `06` afterburner exit,
`e` nozzle exit).

## Repository layout

```
.
├── src/
│   ├── main.m                    # driver: flight conditions, params, prints results
│   ├── JetProTermProject.mlx     # original MATLAB Live Script (same logic, notebook form)
│   └── components/               # per-component physics
│       ├── README.md             # expected function signatures
│       ├── diffuser.m
│       ├── compressor.m
│       ├── combustor.m
│       ├── turbine_and_afterburner.m
│       └── core_nozzle.m
├── LICENSE
└── README.md
```

## Running it

In MATLAB, from the `src/` folder:

```matlab
addpath(genpath('components'))
main
```

Or open `JetProTermProject.mlx` as a Live Script and run it section by section.

## Status

⚠️ The five component functions in `src/components/` are **not yet committed** —
`main.m` calls them but the physics files need to be added before the code will
run. See `src/components/README.md` for the exact signatures each one must
match.

## Validation

The handout provides a test case for debugging (Prc = 30, Prf = 1.2,
bypass = 2, bleed = 0.1, f = 0.018, f_ab = 0.010, at M = 1.5, T_a = 220 K,
p_a = 10 kPa). A subset of the expected outputs:

| Quantity | Expected |
|---|---|
| Compressor exit T_03 | 956.9 K |
| Burner exit T_04 | 1689 K |
| Turbine exit T_05.1 | 1081 K |
| Core exhaust velocity u_e | 1183 m/s |
| Specific thrust | 0.645 kN·s/kg |
| TSFC | 0.0434 kg/(kN·s) |
| Thermal efficiency | 50.2 % |

Matching these confirms the component functions and the marching logic are
correct.

## Notes

This was a course project for AE4451. The problem specification is the
instructor's material and is summarised here rather than redistributed.
