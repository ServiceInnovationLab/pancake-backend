import React from 'react';
import { Form, Field } from 'react-final-form';

export function SummarySearch(fetchRebatesByName) {
  return (
    <Form
      onSubmit={fetchRebatesByName}
    >
      {({ handleSubmit }) => (
        <form className="pure-form" onSubmit={handleSubmit}>
          <label>
            Name
            <Field
              className='rebate-search-field rebate-search-input'
              name="name"
              component="input"
              placeholder="E.g. John Doe"
            />
          </label>
          <button className="pure-button pure-button-primary rebate-search-button" type="submit">
            Search
          </button>
        </form>
      )}
    </Form>
  );
}