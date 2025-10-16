using Microsoft.EntityFrameworkCore;
using ClientesApp.Models;

namespace ClientesApp.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }

        public DbSet<Cliente> Clientes => Set<Cliente>();
        public DbSet<PendienteCliente> PendientesCliente => Set<PendienteCliente>();

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Cliente>(e =>
            {
                e.HasKey(x => x.Id);
                e.Property(x => x.Nombre).HasMaxLength(200).IsRequired();
                e.Property(x => x.Email).HasMaxLength(200);
                e.Property(x => x.Telefono).HasMaxLength(50);
            });

            modelBuilder.Entity<PendienteCliente>(e =>
            {
                e.HasKey(x => x.Id);
                e.Property(x => x.DescripcionSolicitud).HasMaxLength(2000).IsRequired();
                e.Property(x => x.Estado).HasMaxLength(50).IsRequired();
                e.Property(x => x.NotasAdicionales).HasMaxLength(2000);

                e.HasOne(x => x.Cliente)
                    .WithMany(c => c.Pendientes)
                    .HasForeignKey(x => x.ClienteId)
                    .OnDelete(DeleteBehavior.Cascade);
            });
        }
    }
}

