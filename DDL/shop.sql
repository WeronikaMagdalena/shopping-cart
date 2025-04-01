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
    createdAt TIMESTAMP
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
    createdAt TIMESTAMP,
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

-- Triggers

CREATE OR REPLACE TRIGGER trg_user_before_insert
BEFORE INSERT ON c##shop.users
FOR EACH ROW
BEGIN
   :NEW.userId := c##shop."USER_SEQ".NEXTVAL;
END;

CREATE TRIGGER trg_discountCode_before_insert
BEFORE INSERT ON c##shop.discountCode
FOR EACH ROW
BEGIN
   :NEW.discountCodeId := c##shop."DISCOUNTCODE_SEQ".NEXTVAL;
END;

CREATE TRIGGER trg_address_before_insert
BEFORE INSERT ON c##shop.address
FOR EACH ROW
BEGIN
   :NEW.addressId := c##shop."ADDRESS_SEQ".NEXTVAL;
END;

CREATE OR REPLACE TRIGGER trg_product_before_insert
BEFORE INSERT ON c##shop.product
FOR EACH ROW
BEGIN
   :NEW.productId := c##shop."PRODUCT_SEQ".NEXTVAL;
END;

CREATE OR REPLACE TRIGGER trg_orders_before_insert
BEFORE INSERT ON c##shop.orders
FOR EACH ROW
BEGIN
   :NEW.orderId := c##shop."ORDER_SEQ".NEXTVAL;
END;

CREATE OR REPLACE TRIGGER trg_orderItem_before_insert
BEFORE INSERT ON c##shop.orderItem
FOR EACH ROW
BEGIN
   :NEW.orderItemId := c##shop."ORDERITEM_SEQ".NEXTVAL;
END;

CREATE OR REPLACE TRIGGER trg_productReview_before_insert
BEFORE INSERT ON c##shop.productReview
FOR EACH ROW
BEGIN
   :NEW.productReviewId := c##shop."PRODUCTREVIEW_SEQ".NEXTVAL;
END;

CREATE OR REPLACE TRIGGER trg_cart_before_insert
BEFORE INSERT ON c##shop.cart
FOR EACH ROW
BEGIN
   :NEW.cartId := c##shop."CART_SEQ".NEXTVAL;
END;

CREATE OR REPLACE TRIGGER trg_cartItem_before_insert
BEFORE INSERT ON c##shop.cartItem
FOR EACH ROW
BEGIN
   :NEW.cartItemId := c##shop."CARTITEM_SEQ".NEXTVAL;
END;