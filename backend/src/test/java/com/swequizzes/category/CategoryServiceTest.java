package com.swequizzes.category;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CategoryServiceTest {

    @Mock CategoryRepository categoryRepository;
    @InjectMocks CategoryService categoryService;

    private Category build(Long id, String name, String slug) {
        Category c = new Category();
        c.setId(id);
        c.setName(name);
        c.setSlug(slug);
        return c;
    }

    @Test
    void findAll_returnsAllCategories() {
        when(categoryRepository.findAll()).thenReturn(List.of(
                build(1L, "AWS", "aws"),
                build(2L, "Java", "java")
        ));

        List<Category> result = categoryService.findAll();

        assertThat(result).hasSize(2);
        assertThat(result).extracting(Category::getSlug).containsExactly("aws", "java");
    }

    @Test
    void findById_returnsCategoryWhenFound() {
        Category cat = build(1L, "AWS", "aws");
        when(categoryRepository.findById(1L)).thenReturn(Optional.of(cat));

        Category result = categoryService.findById(1L);

        assertThat(result.getName()).isEqualTo("AWS");
    }

    @Test
    void findById_throwsWhenNotFound() {
        when(categoryRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> categoryService.findById(99L))
                .isInstanceOf(NoSuchElementException.class)
                .hasMessageContaining("99");
    }

    @Test
    void save_persistsCategory() {
        Category cat = build(null, "Angular", "angular");
        Category saved = build(3L, "Angular", "angular");
        when(categoryRepository.save(cat)).thenReturn(saved);

        Category result = categoryService.save(cat);

        assertThat(result.getId()).isEqualTo(3L);
    }
}
