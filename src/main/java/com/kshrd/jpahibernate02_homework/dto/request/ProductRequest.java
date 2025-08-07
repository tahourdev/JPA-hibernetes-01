package com.kshrd.jpahibernate02_homework.dto.request;

import com.kshrd.jpahibernate02_homework.model.Product;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.*;

import java.math.BigDecimal;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
public class ProductRequest {

    @NotBlank(message = "Name must not be blank")
    private String name;

    @NotNull(message = "Price must not be null")
    @Positive(message = "Price must be positive and not zero")
    private BigDecimal price;

    @NotNull(message = "Quantity must not be null")
    @Positive(message = "Quantity must be positive and not zero")
    private Integer quantity;

    public Product toEntity() {
        return Product.builder()
                .name(this.getName())
                .quantity(this.getQuantity())
                .price(this.getPrice())
                .build();
    }

    public Product toEntity(Long id) {
        return Product.builder()
                .id(id)
                .name(this.getName())
                .quantity(this.getQuantity())
                .price(this.getPrice())
                .build();
    }
}
