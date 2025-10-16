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

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Cliente>(e =>
            {
                e.HasKey(x => x.Id);
                e.Property(x => x.Nombre).HasMaxLength(200).IsRequired();
                e.Property(x => x.Email).HasMaxLength(200);
                e.Property(x => x.Telefono).HasMaxLength(50);
            });
        }
    }
}

