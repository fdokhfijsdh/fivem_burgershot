let currentOrder = [];
const menuItems = {
    // Menus / Boxes
    'box-classic': { name: 'Classic Box', price: 8.99 },
    'box-veggie': { name: 'Veggie Box', price: 9.99 },
    'box-fusion': { name: 'Fusion Box', price: 10.99 },
    'box-bbq': { name: 'BBQ Box', price: 11.99 },
    'box-sweet': { name: 'Sweet Box', price: 12.99 },
    'box-spicy': { name: 'Spicy Box', price: 13.99 },
    'box-vegan': { name: 'Vegan Box', price: 14.99 },

    // Burgers
    'burger-bbq': { name: 'BBQ Burger', price: 5.99 },
    'burger-veggie': { name: 'Veggie Burger', price: 6.99 },
    'burger-spicychicken': { name: 'Spicy Chicken Burger', price: 7.99 },
    'burger-starrynightbeef': { name: 'Starry Night Beef Burger', price: 8.99 },
    'burger-fusion': { name: 'Fusion Burger', price: 9.99 },
    'burger-meteoritemushroom' : { name: 'Meteorite Mushroom Burger', price: 10.99 },
    'burger-brisket': { name: 'Brisket Burger', price: 11.99 },

    // Sides
    'side-meteoritefries': { name: 'Meteorite Fries', price: 2.99 },
    'side-stellarsweetpotatofries': { name: 'Stellar Sweet Potato Fries', price: 3.49 },
    'side-veggieslaw': { name: 'Veggie Slaw', price: 3.99 },
    'side-corndogs': { name: 'Corn Dogs', price: 4.49 },
    'side-meteoriteonionrings': { name: 'Meteorite Onion Rings', price: 4.99 },
    'side-jalapenopoppers': { name: 'Jalapeño Poppers', price: 5.49 },
    'side-galaxysalad': { name: 'Galaxy Salad', price: 5.99 },

    // Drinks
    'drink-lemonade': { name: 'Lemonade', price: 2.99 },
    'drink-icedtea': { name: 'Iced Tea', price: 3.49 },
    'drink-fizz' : { name: 'Fizz', price: 3.99 },
    'drink-smoothie': { name: 'Smoothie', price: 4.49 },
    'drink-grapepunch': { name: 'Grape Punch', price: 4.99 },
    'drink-coldbrew': { name: 'Cold Brew', price: 5.49 },
    'drink-citruscooler': { name: 'Citrus Cooler', price: 5.99 },
    'drink-bluelemonade': { name: 'Blue Lemonade', price: 6.49 },
    'drink-gingerale': { name: 'Ginger Ale', price: 6.99 },
    'drink-chocolate' : { name: 'Choco Latte', price: 7.49 },
    'drink-mojito': { name: 'Mojito', price: 7.99 },
    'drink-infusedwater': { name: 'Infused Water', price: 4.49 },

    // Desserts
    'dessert-nebulaswirl' : { name: 'Nebula Swirl', price: 3.99 },
    'dessert-galacticmint' : { name: 'Galactic Mint', price: 4.49 },
    'dessert-stardustcrunch' : { name: 'Stardust Crunch', price: 4.99 },
    'dessert-galaxyberry' : { name: 'Galaxy Berry', price: 5.49 },
    'dessert-blackholechocolate' : { name: 'Black Hole Chocolate', price: 5.99 },
    'dessert-supernovacitrus' : { name: 'Supernova Citrus', price: 6.49 },
    'dessert-spacecookiedough' : { name: 'Space Cookie Dough', price: 6.99 },
    'dessert-bluemooneclipse' : { name: 'Blue Moon Eclipse', price: 7.49 },
};

// Update datetime to show UTC time in specified format
function updateDateTime() {
    const now = new Date();
    const options = {
        timeZone: 'Europe/Berlin',
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
    };
    const formatter = new Intl.DateTimeFormat('de-DE', options);
    const parts = formatter.formatToParts(now);
    const dateTime = parts.reduce((acc, part) => {
        if (part.type === 'day' || part.type === 'month' || part.type === 'year') {
            acc.date.push(part.value);
        } else if (part.type === 'hour' || part.type === 'minute') {
            acc.time.push(part.value);
        }
        return acc;
    }, { date: [], time: [] });

    const formattedDate = `${dateTime.date.join('.')}`;
    const formattedTime = `${dateTime.time.join(':')}`;
    document.getElementById('datetime').textContent = `${formattedDate} - ${formattedTime}`;
}

// Initialize
document.addEventListener('DOMContentLoaded', function() {
    // Set initial display state to none
    document.body.style.display = "none";
    
    // Start datetime updates
    updateDateTime();
    setInterval(updateDateTime, 60000); // Update every minute

    // Add exit button handler
    document.getElementById('exit-button').addEventListener('click', function() {
        fetch(`https://${GetParentResourceName()}/exit-button`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({})
        });
    });

    // Add event listeners to tab buttons
    document.querySelectorAll('.tab-button').forEach(button => {
        button.addEventListener('click', function() {
            document.querySelectorAll('.tab-button').forEach(btn => btn.classList.remove('active'));
            document.querySelectorAll('.menu-section').forEach(section => section.style.display = 'none');

            const tab = this.getAttribute('data-tab');
            document.getElementById(`tab-${tab}`).style.display = 'block';
            this.classList.add('active');
        });
    });

    // Add event listeners to order buttons
    document.querySelectorAll('.order-btn').forEach(button => {
        button.addEventListener('click', function() {
            const menuItem = this.parentElement;
            const itemId = menuItem.dataset.id;
            addToOrder(itemId);
        });
    });

    // Clear order button
    document.getElementById('clear-order').addEventListener('click', function() {
        currentOrder = [];
        updateOrderDisplay();
    });
});

function addToOrder(itemId) {
    const item = menuItems[itemId];
    currentOrder.push({
        id: itemId,
        name: item.name,
        price: item.price
    });
    updateOrderDisplay();
}

function updateOrderDisplay() {
    const orderItems = document.getElementById('order-items');
    orderItems.innerHTML = '';
    
    let total = 0;
    
    currentOrder.forEach((item, index) => {
        const itemElement = document.createElement('div');
        itemElement.classList.add('order-item');
        itemElement.innerHTML = `
            <span>${item.name}</span>
            <span>$${item.price.toFixed(2)}</span>
            <button onclick="removeFromOrder(${index})">❌</button>
        `;
        orderItems.appendChild(itemElement);
        total += item.price;
    });

    document.getElementById('order-total').textContent = `Gesamt: $${total.toFixed(2)}`;
}

function removeFromOrder(index) {
    currentOrder.splice(index, 1);
    updateOrderDisplay();
}

// Handle visibility
window.addEventListener('message', function(event) {
    var item = event.data;
    if (item.type === "ui") {
        document.body.style.display = item.status ? "flex" : "none";
    }
});

// Make sure body is hidden by default
document.body.style.display = "none";