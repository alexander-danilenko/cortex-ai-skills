# Architecture

Directory layout, naming, and where a class belongs.

## Module layout

One directory per role, and the role is in the filename:

```text
core/shipment/
├── shipment.module.ts
├── index.ts                  exports only the module
├── service/
│   ├── shipment.service.ts
│   ├── interface/            this service's own contract
│   └── index.ts
├── interface/                shapes other modules consume
├── enum/  const/  type/
└── exception/
```

- **The module's root barrel exports only the `.module.ts`.** Consumers write `import { ShipmentModule } from "@core/shipment"` and get exactly that. Everything else stays free to move, because nothing outside the module can name it.
- **Each directory carries its own `index.ts`, and nothing imports a barrel that re-exports it.** That cycle type-checks cleanly and fails at runtime with an undefined class, usually on the deploy nobody was watching. Import the file path directly to break it. The Nest docs give the same rule from the other side: a file must never reach its own directory's barrel to get at a sibling — `cats/cats.controller` importing from `cats` to reach `cats/cats.service` is the canonical cycle.
- **An implementation's interface lives beside the implementation.** The module-level `interface/` is for shapes other modules consume. Kept together, the pair moves as one unit and it stays obvious which contract a class actually implements.
- **Nest implementation detail under whatever owns it.** A directory of classes that only one service drives belongs inside that service's directory. Sitting beside it, they read as module-level API and get imported by someone who shouldn't.
- **Filenames say the role** — `{name}.{type}.ts`, where `type` is `service`, `controller`, `module`, `dto`, `interface`, `enum`, `exception`, `event`, `listener`, `guard`, `pipe`, `handler`, `repository`. Never invent one, and never `.helper.ts` or `.utils.ts`: those are the names classes nobody could place accumulate under.

## Picking the primitive

- **Reach for CQRS when a flow spans modules or has several entry points** — the controller builds a `Command` or `Query` and hands it to the bus, and the handler becomes the one place that flow exists. Below that bar, a service method is less ceremony and just as testable; adopt CQRS because the flow asked for it, not by default.
- **Pick by what triggers the code.** `@CommandHandler` / `@QueryHandler` for request-driven flows, an `@OnEvent` listener for a reaction to something that already happened, a plain service method for what another service calls directly. Preference is not a reason — the trigger is.
- **Give a command one documented `readonly` field per input and construct it from an object literal.** Positional arguments of the same type are swappable at the call site with nothing to catch it.

  ```ts
  public constructor(data: Pick<CancelShipmentCommand, "actor" | "reason" | "shipmentId">) {
    super()
    Object.assign(this, data)
  }
  ```

## Boundaries to the outside world

- **No domain service imports a vendor SDK.** The payment gateway, the database client, the mail provider each get a wrapper module and everything else depends on the wrapper. A major SDK bump or a vendor swap is then one module's problem rather than a repo-wide search.
- **The persistence class owns the collection or table name and the transaction**, and hands back domain shapes. Once a query literal appears in a service, the storage rules live in two places and only one of them is tested.
- **Persisted field names are independent of your in-memory shape.** Pick a casing for stored documents and event payloads and map at the boundary — otherwise renaming a TypeScript property becomes a data migration, and nothing warns you.

## Lazy-loaded modules

`LazyModuleLoader` exists for cold-start-sensitive workloads (serverless, workers), not for trimming a monolith's boot time. It loads providers only: controllers, resolvers, and gateways inside a lazily loaded module never register their routes, lifecycle hooks never fire, global enhancers don't apply, and the module can't be global. Treat it as a provider factory, not as a module system.
