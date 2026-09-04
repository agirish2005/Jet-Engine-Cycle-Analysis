# Component functions

Each function models one engine component, taking the incoming stagnation
state (and the relevant design parameters) and returning the exit state plus
any work/limit terms the driver needs. `main.m` chains them together.

Drop the five `.m` files in this folder. The driver expects these exact
signatures (inferred from the call sites in `main.m`):

| Function | Signature |
|---|---|
| Diffuser | `[P02, T02] = diffuser(Ta, pa, M)` |
| Compressor | `[P03, T03, w3, Cpc] = compressor(P02, T02, Prc)` |
| Combustor | `[T04, p04, fmax, R, Cp4] = combustor(f, T03, p03, Cpc)` |
| Turbine + afterburner | `[T06, p06, wt, T05, p05] = turbine_and_afterburner(T04, p04, b, wc, f, f_ab)` |
| Core nozzle | `[u_e, T_e, p_e, thrust_specific, TSFC] = core_nozzle(T06, p06, p_a, T_a, M, f, f_ab)` |

Symbols follow the handout's station numbering (`02` diffuser exit, `03`
compressor exit, `04` burner exit, `05` turbine exit, `06` afterburner
exit, `e` nozzle exit).
