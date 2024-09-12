using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    class SsCostmastConfiguration : IEntityTypeConfiguration<SsCostmast>
    {
        public void Configure(EntityTypeBuilder<SsCostmast> entity)
        {
            
            entity.ToView("SS_COSTMAST");

            entity.Property(e => e.Abbr).IsUnicode(false);

            entity.Property(e => e.Active).HasPrecision(1);

            entity.Property(e => e.Activity).HasPrecision(1);

            entity.Property(e => e.Bu).IsUnicode(false);

            entity.Property(e => e.ChangedNemps).HasPrecision(3);

            entity.Property(e => e.Closed).HasPrecision(1);

            entity.Property(e => e.Comp).IsUnicode(false);

            entity.Property(e => e.CostType)
                        .IsUnicode(false)
                        .IsFixedLength(true);

            entity.Property(e => e.Costcode)
                        .IsUnicode(false)
                        .IsFixedLength(true);

            entity.Property(e => e.Costgroup)
                        .IsUnicode(false)
                        .IsFixedLength(true);

            entity.Property(e => e.Costgrp).IsUnicode(false);

            entity.Property(e => e.DyHod)
                        .IsUnicode(false)
                        .IsFixedLength(true);

            entity.Property(e => e.GroupChart).HasPrecision(1);

            entity.Property(e => e.Groups)
                        .IsUnicode(false)
                        .IsFixedLength(true);

            entity.Property(e => e.Hod)
                        .IsUnicode(false)
                        .IsFixedLength(true);

            entity.Property(e => e.HodAbbr)
                        .IsUnicode(false)
                        .IsFixedLength(true);

            entity.Property(e => e.Inoffice).HasPrecision(1);

            entity.Property(e => e.ItalianName).IsUnicode(false);

            entity.Property(e => e.Name).IsUnicode(false);

            entity.Property(e => e.Noofemps).HasPrecision(5);

            entity.Property(e => e.ParentCostcode).IsUnicode(false);

            entity.Property(e => e.Phase)
                        .IsUnicode(false)
                        .IsFixedLength(true);

            entity.Property(e => e.Sapcc).IsUnicode(false);

            entity.Property(e => e.Secretary)
                        .IsUnicode(false)
                        .IsFixedLength(true);

            entity.Property(e => e.Tm01Grp)
                        .IsUnicode(false)
                        .IsFixedLength(true);

            entity.Property(e => e.TmaGrp)
                        .IsUnicode(false)
                        .IsFixedLength(true);

        }
    }
}