package com.siga.config;

import com.siga.entity.TipoProducto;
import com.siga.repository.TipoProductoRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DataInitializer implements CommandLineRunner {

    private final TipoProductoRepository repo;

    public DataInitializer(TipoProductoRepository repo) {
        this.repo = repo;
    }

    @Override
    public void run(String... args) {

        if (repo.count() == 0) {

            repo.save(new TipoProducto(
                    "TECNOLOGIA",
                    36,
                    30,
                    "iphone,samsung,xiaomi,tablet,portatil,ordenador",
                    true
            ));

            repo.save(new TipoProducto(
                    "ELECTRODOMESTICO",
                    36,
                    14,
                    "lavadora,nevera,frigorifico,microondas,horno",
                    true
            ));

            repo.save(new TipoProducto(
                    "ROPA",
                    0,
                    30,
                    "camiseta,pantalon,chaqueta,zapatillas,jersey",
                    false
            ));

            repo.save(new TipoProducto(
                    "CALZADO",
                    0,
                    30,
                    "zapatillas,puma,nike,adidas,new balance",
                    false
            ));

            repo.save(new TipoProducto(
                    "HOGAR",
                    24,
                    30,
                    "silla,mesa,lampara,sofa",
                    true
            ));

            repo.save(new TipoProducto(
                    "SUPERMERCADO",
                    0,
                    0,
                    "pollo,pan,leche,arroz,huevo",
                    false
            ));

            repo.save(new TipoProducto(
                    "OTRO",
                    6,
                    15,
                    "",
                    false
            ));
        }
    }
}