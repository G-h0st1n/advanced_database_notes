
DROP TABLE accounts PURGE;

CREATE TABLE accounts (
    account_id   NUMBER PRIMARY KEY,
    owner_name   VARCHAR2(50) NOT NULL,
    balance      NUMBER(10,2) NOT NULL CHECK (balance >= 0)
);

INSERT INTO accounts VALUES (1, 'Alice',  1000.00);
INSERT INTO accounts VALUES (2, 'Bob',     500.00);
INSERT INTO accounts VALUES (3, 'Charlie', 250.00);
COMMIT;

-- Verify starting state
SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;
-- Expected: Alice=1000, Bob=500, Charlie=250

 

 

-- Lesson 04: Class Exercises
-- Students: work through these in order. Don't skip the verify steps.

-- ============================================================
-- EXERCISE 1: Manual transaction (warm-up)
-- ============================================================
-- Transfer $50 from Charlie (3) to Alice (1) using BEGIN / COMMIT manually.
-- Before: verify balances. After COMMIT: verify again.

-- Your SQL here:

BEGIN
    -- Transfer $50 from Charlie (3) to Alice (1)
    UPDATE accounts SET balance = balance - 50 WHERE account_id = 3;
    UPDATE accounts SET balance = balance + 50 WHERE account_id = 1;
    COMMIT;
END;
/

SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;
-- Expected: Alice=1050, Bob=500, Charlie=200
 
-- ============================================================
-- EXERCISE 2: Catch yourself with ROLLBACK
-- ============================================================
-- Start a transfer of $10,000 from Bob (2) to Charlie (3).
-- Before committing, check the balances. Does Bob have enough?
-- Use ROLLBACK to undo. Verify balances restored.

-- Your SQL here:

BEGIN
   
    UPDATE accounts SET balance = balance - 10000 WHERE account_id = 2;
    UPDATE accounts SET balance = balance + 10000 WHERE account_id = 3;

    ROLLBACK;
END;
/

SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;
-- Expected: Alice=1050, Bob=500, Charlie=200 (unchanged)

-- ============================================================
-- EXERCISE 3: SAVEPOINT checkpoint
-- ============================================================
-- You need to:
-- 1. Add $25 to Alice's balance
-- 2. Set a savepoint
-- 3. Deduct $25 from Charlie's balance (wrong account — you meant Bob)
-- 4. Rollback to savepoint
-- 5. Deduct $25 from Bob's balance instead
-- 6. Commit

-- Your SQL here:

 BEGIN
 
    UPDATE accounts SET balance = balance + 25 WHERE account_id = 1;

    SAVEPOINT before_deduction;

    UPDATE accounts SET balance = balance - 25 WHERE account_id = 3;

    ROLLBACK TO SAVEPOINT before_deduction;

    UPDATE accounts SET balance = balance - 25 WHERE account_id = 2;

    COMMIT;
END;
/

SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;


-- ============================================================
-- EXERCISE 4: Write your own stored procedure
-- ============================================================
-- Create a procedure called deposit_funds(p_account_id, p_amount)
-- It should:
-- 1. Validate that p_amount > 0 (raise error if not)
-- 2. Add p_amount to the account balance
-- 3. COMMIT on success
-- 4. ROLLBACK + re-raise on any error
-- Test it with: EXEC deposit_funds(3, 75);

-- Your SQL here:

 CREATE OR REPLACE PROCEDURE deposit_funds (
    p_account_id  IN accounts.account_id%TYPE,
    p_amount      IN accounts.balance%TYPE
)
AS
    e_invalid_amount EXCEPTION;
BEGIN
    IF p_amount <= 0 THEN
        RAISE e_invalid_amount;
    END IF;

    UPDATE accounts
    SET    balance = balance + p_amount
    WHERE  account_id = p_account_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Account not found: ' || p_account_id);
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Deposit of ' || p_amount || ' committed for account ' || p_account_id);

EXCEPTION
    WHEN e_invalid_amount THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, 'Deposit amount must be greater than zero.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END deposit_funds;
/

BEGIN
    deposit_funds(3, 75);
END;
/

SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;
-- Expected: Alice=1075, Bob=475, Charlie=275

-- ============================================================
-- EXERCISE 5: Discussion
-- ============================================================
-- Answer these in words (no SQL needed):

-- Q1: You're building a patient appointment booking system.
-- A booking requires:
--   a) Reserve the time slot
--   b) Create the appointment record
--   c) Send a confirmation notification
-- Which of these should be inside the transaction? Which should be outside? Why?
/*
Steps a and b should be inside the transaction because they need to happen together 
if one failsthe other needs to be undone. The notification, should be outside 
because you can't rollback a sent email

-- Q2: Your stored procedure calls COMMIT at the end.
-- A developer calls your procedure from inside their own larger transaction.
-- What problem does this create?
When your procedure calls COMMIT, it commits everything in the current session, not just its own changes. 
So if a developer calls your procedure in the middle of their own larger transaction, your COMMIT will 
permanently save their unfinished work too, and they lose the ability to rollback if something goes wrong later.
The fix is to let the caller decide when to commit, not the procedure.

-- Q3: You have a function called calculate_copay() and a procedure called post_payment().
-- A colleague wants to use calculate_copay() inside a SELECT statement.
-- Can they? Can they do the same with post_payment()? Why or why not?
A function like calculate_copay() can be used inside a SELECT because it returns a value, which is exactly what SQL needs to evaluate an expression in a query.
A procedure like post_payment() cannot be used inside a SELECT because procedures don't return a value
*/