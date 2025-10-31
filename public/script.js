// Shopping cart functionality
let cart = JSON.parse(localStorage.getItem('sealedAutosCart')) || [];

// Add to cart functionality
document.addEventListener('DOMContentLoaded', function() {
    const addToCartButtons = document.querySelectorAll('.add-to-cart');
    
    addToCartButtons.forEach(button => {
        button.addEventListener('click', function() {
            const partId = parseInt(this.getAttribute('data-id'));
            addToCart(partId);
        });
    });
    
    updateCartCount();
});

function addToCart(partId) {
    // In a real app, you'd fetch part details from the server
    const part = {
        id: partId,
        name: `Mercedes Part ${partId}`,
        price: 100 + (partId * 25), // Example pricing
        quantity: 1
    };
    
    const existingItem = cart.find(item => item.id === partId);
    
    if (existingItem) {
        existingItem.quantity += 1;
    } else {
        cart.push(part);
    }
    
    localStorage.setItem('sealedAutosCart', JSON.stringify(cart));
    updateCartCount();
    
    // Show confirmation
    showNotification('Part added to cart!');
}

function updateCartCount() {
    const cartCount = document.getElementById('cart-count');
    if (cartCount) {
        const totalItems = cart.reduce((sum, item) => sum + item.quantity, 0);
        cartCount.textContent = totalItems;
    }
}

function showNotification(message) {
    // Create notification element
    const notification = document.createElement('div');
    notification.style.cssText = `
        position: fixed;
        top: 100px;
        right: 20px;
        background: #00D2FF;
        color: white;
        padding: 15px 20px;
        border-radius: 5px;
        z-index: 1000;
        animation: slideIn 0.3s ease;
    `;
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    // Remove after 3 seconds
    setTimeout(() => {
        notification.remove();
    }, 3000);
}

// Add CSS for animation
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
`;
document.head.appendChild(style);