package com.kshrd.jpahibernate02_homework.model;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;

@Setter
@Getter
@Entity(name = "products")
@Table(name = "products")
@Builder
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

//    @Column()
    private String name;

    private BigDecimal price;

    private Integer quantity;
}
