using System;
using System.ComponentModel.DataAnnotations;

namespace ClientesApp.Models
{
    public class PendienteCliente
    {
        public int Id { get; set; }

        [Required]
        public int ClienteId { get; set; }

        public Cliente? Cliente { get; set; }

        [Required]
        [StringLength(2000)]
        public string DescripcionSolicitud { get; set; } = string.Empty;

        public bool RequiereMasInformacion { get; set; }

        public bool InformacionRecibida { get; set; }

        public bool EsViableTecnicamente { get; set; }

        [DataType(DataType.Date)]
        public DateTime FechaLimiteEntrega { get; set; } = DateTime.Today.AddDays(7);

        [StringLength(2000)]
        public string? NotasAdicionales { get; set; }

        [Required]
        [StringLength(50)]
        public string Estado { get; set; } = "Pendiente";
    }
}
