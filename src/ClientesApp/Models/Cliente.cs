using System.ComponentModel.DataAnnotations;

namespace ClientesApp.Models
{
    public class Cliente
    {
        public int Id { get; set; }

        [Required]
        public string Nombre { get; set; } = string.Empty;

        [EmailAddress]
        public string? Email { get; set; }

        public string? Telefono { get; set; }

        public DateTime FechaRegistro { get; set; } = DateTime.UtcNow;
    }
}

