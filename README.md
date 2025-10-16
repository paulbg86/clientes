# ClientesApp (Blazor Server + SQL Server)

Aplicación Blazor Server mínima para capturar clientes y guardarlos en SQL Server mediante Entity Framework Core.

## Estructura
- `src/ClientesApp`: Proyecto web (Blazor Server)
- `src/ClientesApp/Models/Cliente.cs`: Entidad de dominio
- `src/ClientesApp/Data/AppDbContext.cs`: DbContext (EF Core)
- `src/ClientesApp/Pages/Clientes.razor`: Página para alta y listado de clientes

## Requisitos
- .NET SDK 8.0+
- SQL Server (local o remoto)

## Configuración de conexión
Edita `src/ClientesApp/appsettings.json:3` y ajusta la cadena:
```
"DefaultConnection": "Server=.\\SQLEXPRESS;Database=ClientesDb;Trusted_Connection=True;TrustServerCertificate=True;"
```
Ejemplos:
- LocalDB: `Server=(localdb)\\MSSQLLocalDB;Database=ClientesDb;Trusted_Connection=True;`
- SQL Server default: `Server=.;Database=ClientesDb;Trusted_Connection=True;TrustServerCertificate=True;`

## Restaurar, migraciones y ejecución
Desde `src/ClientesApp`:

1) Restaurar paquetes
```
dotnet restore
```

2) Agregar migración inicial (si no existe la BD)
```
dotnet tool install --global dotnet-ef
setx PATH "%PATH%;%USERPROFILE%\\.dotnet\\tools"
dotnet ef migrations add InitialCreate
```

3) Aplicar migraciones a la base de datos
```
dotnet ef database update
```

4) Ejecutar la app
```
dotnet run
```
Navega a `https://localhost:5001` o `http://localhost:5000`.

## Notas
- El componente `Clientes.razor` usa `AppDbContext` directamente para simplicidad. En entornos más grandes, considera un servicio de aplicación/repositorio.
- Para ambientes corporativos, configura `User ID`/`Password` en la cadena de conexión en lugar de `Trusted_Connection`.
