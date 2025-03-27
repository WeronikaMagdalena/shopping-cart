CREATE SEQUENCE discountCode_seq;
CREATE SEQUENCE user_seq;
CREATE SEQUENCE address_seq;
CREATE SEQUENCE product_seq;
CREATE SEQUENCE order_seq;
CREATE SEQUENCE orderItem_seq;
CREATE SEQUENCE productReview_seq;
CREATE SEQUENCE cart_seq;
CREATE SEQUENCE cartItem_seq;


CREATE TABLE discountCode (
    discountCodeId NUMBER PRIMARY KEY,
    code VARCHAR2(10),
    description VARCHAR2(4000),
    startDate DATE,
    endDate DATE,
    promotionDiscount NUMBER(2,1)
);

CREATE TABLE users (
    userId NUMBER PRIMARY KEY,
    username VARCHAR2(50),
    email VARCHAR2(100),
    password VARCHAR2(255),
    firstName VARCHAR2(50),
    lastName VARCHAR2(50),
    phoneNumber VARCHAR2(20),
    gender CHAR(1),
    birthDate DATE,
    createdAt TIMESTAMP WITH TIME ZONE
);

CREATE TABLE address (
    addressId NUMBER PRIMARY KEY,
    userId NUMBER NOT NULL,
    houseNumber VARCHAR2(10),
    street VARCHAR2(100),
    city VARCHAR2(100),
    province VARCHAR2(20),
    country VARCHAR2(60),
    postalCode VARCHAR2(20),
    CONSTRAINT fk_address_user FOREIGN KEY (userId) REFERENCES users(userId)
);

CREATE TABLE product (
    productId NUMBER PRIMARY KEY,
    title VARCHAR2(100),
    price NUMBER(10,2),
    description VARCHAR2(4000),
    stockQuantity NUMBER,
    imageUrl VARCHAR2(255),
    dateAddedToStock DATE,
    dateRemovedFromStock DATE
);

CREATE TABLE orders (
    orderId NUMBER PRIMARY KEY,
    userId NUMBER NOT NULL,
    paymentMethod VARCHAR2(20),
    orderDate DATE,
    deliveryDate DATE,
    orderStatus VARCHAR2(20),
    subTotalCost NUMBER(10,2),
    promotionId NUMBER,
    tax NUMBER(4,2),
    shippingCost NUMBER(6,2),
    totalCost NUMBER(10,2),
    CONSTRAINT fk_order_user FOREIGN KEY (userId) REFERENCES users(userId),
    CONSTRAINT fk_order_discount FOREIGN KEY (promotionId) REFERENCES discountCode(discountCodeId)
);

CREATE TABLE orderItem (
    orderItemId NUMBER PRIMARY KEY,
    orderId NUMBER NOT NULL,
    productId NUMBER NOT NULL,
    quantity NUMBER,
    CONSTRAINT fk_orderItem_order FOREIGN KEY (orderId) REFERENCES orders(orderId),
    CONSTRAINT fk_orderItem_product FOREIGN KEY (productId) REFERENCES product(productId)
);

CREATE TABLE productReview (
    productReviewId NUMBER PRIMARY KEY,
    productId NUMBER NOT NULL,
    rating NUMBER,
    title VARCHAR2(100),
    reviewText VARCHAR2(4000),
    reviewDate DATE,
    helpfulVotes NUMBER,
    unhelpfulVotes NUMBER,
    CONSTRAINT fk_productReview_product FOREIGN KEY (productId) REFERENCES product(productId)
);

CREATE TABLE cart (
    cartId NUMBER PRIMARY KEY,
    userId NUMBER NOT NULL,
    createdAt TIMESTAMP WITH TIME ZONE,
    totalItems NUMBER,
    totalPrice NUMBER(10,2),
    cartStatus VARCHAR2(20),
    CONSTRAINT fk_cart_user FOREIGN KEY (userId) REFERENCES users(userId)
);

CREATE TABLE cartItem (
    cartItemId NUMBER PRIMARY KEY,
    cartId NUMBER NOT NULL,
    productId NUMBER NOT NULL,
    quantity NUMBER,
    CONSTRAINT fk_cartItem_cart FOREIGN KEY (cartId) REFERENCES cart(cartId),
    CONSTRAINT fk_cartItem_product FOREIGN KEY (productId) REFERENCES product(productId)
);

ALTER TABLE cart ADD CONSTRAINT unique_cart_user UNIQUE (userId);
